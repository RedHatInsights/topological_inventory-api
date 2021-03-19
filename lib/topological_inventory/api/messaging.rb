require "topological_inventory/api/clowder_config"

module TopologicalInventory
  module Api
    module Messaging
      def self.client
        require "manageiq-messaging"

        @client ||= ManageIQ::Messaging::Client.open({
          :protocol => :Kafka,
          :host     => TopologicalInventory::Api::ClowderConfig.instance['kafkaHost'],
          :port     => TopologicalInventory::Api::ClowderConfig.instance['kafkaPort'],
          :encoding => "json"
        })
      end
    end
  end
end
