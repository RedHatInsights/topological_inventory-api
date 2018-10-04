require "topological_inventory/schema"
require "manageiq-messaging"

module TopologicalInventory
  module Persister
    class Worker
      def initialize(messaging_client_opts = {})
        self.finished              = Concurrent::AtomicBoolean.new(false)
        self.log                   = Logger.new(STDOUT)
        self.messaging_client_opts = default_messaging_opts.merge(messaging_client_opts)

        InventoryRefresh.logger = log
      end

      def run
        # Open a connection to the messaging service
        self.client = ManageIQ::Messaging::Client.open(messaging_client_opts)

        # Wait for messages to be processed
        client.subscribe_topic(queue_opts) do |_, _, payload|
          process_payload(payload)
        end
      ensure
        client&.close
      end

      def stop
        client&.close
        self.client = nil
      end

      private

      attr_accessor :log, :finished, :messaging_client_opts, :client

      def process_payload(payload)
        source = Source.find_by(:uid => payload["source"])
        raise "Couldn't find source with uid #{payload["source"]}" if source.nil?

        schema_name  = payload.dig("schema", "name")
        schema_klass = schema_klass_name(schema_name).safe_constantize
        raise "Invalid schema #{schema_name}" if schema_klass.nil?

        persister = schema_klass.from_hash(payload, source)
        InventoryRefresh::SaveInventory.save_inventory(source, persister.inventory_collections)
      rescue => err
        log.error(err)
      end

      def schema_klass_name(name)
        "TopologicalInventory::Schema::#{name}"
      end

      def queue_opts
        {
          :service => "topological_inventory-persister",
        }
      end

      def default_messaging_opts
        {
          :protocol   => :Kafka,
          :client_ref => "persister-worker",
          :group_ref  => "persister-worker",
        }
      end
    end
  end
end
