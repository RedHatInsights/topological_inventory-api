require 'insights/api/common/open_api/generator'
class OpenapiGenerator < Insights::API::Common::OpenApi::Generator
  def handle_custom_route_action(route_action, verb, primary_collection)
    if route_action == 'IconData' && verb == "get"
      openapi_show_image_media_type_description(route_action, primary_collection)
    end
  end

  def openapi_show_image_media_type_description(klass_name, primary_collection)
    primary_collection = nil if primary_collection == klass_name
    {
      "summary"     => "Show an existing #{primary_collection} #{klass_name}",
      "operationId" => "show#{primary_collection}#{klass_name}",
      "description" => "Returns a #{primary_collection} #{klass_name}",
      "parameters"  => [{ "$ref" => build_parameter("ID") }],
      "responses"   => {
        "200" => {
          "description" => "#{primary_collection} #{klass_name}",
          "content"     => {
            "image/*" => {
              "schema" => {
                "type"   => "string",
                "format" => "binary"
              }
            }
          }
        },
        "404" => {"description" => "Not found"}
      }
    }
  end

  def schemas
    @schemas ||= begin
      super.merge(
        "AppliedInventoriesParametersServicePlan" => {
          "type"                 => "object",
          "additionalProperties" => false,
          "properties"           => {
            "service_parameters" => {
              "type"        => "object",
              "description" => "The provider specific parameters needed to compute list of used service inventories"
            }
          }
        },
        "OrderParametersServiceOffering"          => {
          "type"                 => "object",
          "additionalProperties" => false,
          "properties"           => {
            "service_parameters"          => {
              "type"        => "object",
              "description" => "JSON object with provisioning parameters"
            },
            "provider_control_parameters" => {
              "type"        => "object",
              "description" => "The provider specific parameters needed to provision this service. This might include namespaces, special keys"
            },
            "service_plan_id"             => {
              "$ref" => "##{SCHEMAS_PATH}/ID"
            }
          }
        },
        "OrderParametersServicePlan"              => {
          "type"                 => "object",
          "additionalProperties" => false,
          "properties"           => {
            "service_parameters"          => {
              "type"        => "object",
              "description" => "JSON object with provisioning parameters"
            },
            "provider_control_parameters" => {
              "type"        => "object",
              "description" => "The provider specific parameters needed to provision this service. This might include namespaces, special keys"
            },
          }
        },
        "Tenant"                                  => {
          "type"       => "object",
          "properties" => {
            "id"              => {"$ref" => "##{SCHEMAS_PATH}/ID"},
            "name"            => {"type" => "string", "readOnly" => true, "example" => "Sample Tenant"},
            "description"     => {"type" => "string", "readOnly" => true, "example" => "Description of the Tenant"},
            "external_tenant" => {"type" => "string", "readOnly" => true, "example" => "External tenant identifier"}
          }
        }
      )
    end
  end

  def schema_overrides
    super.merge(
      "Tag" => {
        "type"       => "object",
        "properties" => {
          "tag" => {
            "example"  => "/namespace/architecture=x86_64",
            "readOnly" => true,
            "type"     => "string"
          }
        },
        "additionalProperties" => false
      },
    )
  end

  def generator_read_only_definitions
    @generator_read_only_definitions ||= [
      'Container',
      'ContainerGroup',
      'ContainerImage',
      'ContainerNode',
      'ContainerProject',
      'ContainerResourceQuota',
      'ContainerTemplate',
      'Flavor',
      'OrchestrationStack',
      'ServiceInstance',
      'ServiceInventory',
      'ServiceOffering',
      'ServiceOfferingIcon',
      'ServicePlan',
      'Vm',
      'Volume',
      'VolumeAttachment',
      'VolumeType',
    ].to_set.freeze
  end
end

namespace :openapi do
  desc "Generate the openapi.json contents"
  task :generate, [:graphql] => [:environment] do |_task, args|
    graphql = args[:graphql] == "graphql"
    OpenapiGenerator.new.run(graphql)
  end
end
