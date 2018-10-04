require "inventory_refresh/persister"

module TopologicalInventory
  module Schema
    class Default < InventoryRefresh::Persister
      def initialize_inventory_collections
        add_collection(:container_projects) do |builder|
          builder.add_properties(
            :manager_ref    => [:source_ref],
            :secondary_refs => {:by_name => [:name]}
          )
          builder.add_default_values(:source_id => ->(persister) { persister.manager.id })
        end

        %i(container_groups container_templates service_offerings service_instances service_parameters_sets).each do |model|
          add_collection(model) do |builder|
            builder.add_properties(:manager_ref => [:source_ref])
            builder.add_default_values(:source_id => ->(persister) { persister.manager.id })
          end
        end
      end
    end
  end
end
