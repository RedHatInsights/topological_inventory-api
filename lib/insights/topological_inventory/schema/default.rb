require "inventory_refresh/persister"

module Insights
  module TopologicalInventory
    module Schema
      class Default < InventoryRefresh::Persister
        def initialize_inventory_collections
          %i(container_projects container_groups container_templates
             service_offering service_instances service_parameters_sets).each do |model|
               add_collection(model) do |builder|
                 builder.add_properties(
                   :manager_ref => %i(source_ref),
                 )
                 builder.add_default_values(:ems_id => ->(persister) { persister.manager.id })
               end
             end
        end
      end
    end
  end
end
