require 'manageiq/api/common/open_api/generator'
class OpenapiGenerator < ManageIQ::API::Common::OpenApi::Generator
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
        "OrderParametersServiceOffering" => {
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
            "service_plan_id" => {
              "$ref" => "##{SCHEMAS_PATH}/ID"
            }
          }
        },
        "OrderParametersServicePlan" => {
          "type"                 => "object",
          "additionalProperties" => false,
          "properties"           => {
            "service_parameters" => {
              "type"        => "object",
              "description" => "JSON object with provisioning parameters"
            },
            "provider_control_parameters" => {
              "type"        => "object",
              "description" => "The provider specific parameters needed to provision this service. This might include namespaces, special keys"
            },
          }
        },
        "Tagging" => {
          "type"       => "object",
          "properties" => {
            "tag_id" => {"$ref" => "##{SCHEMAS_PATH}/ID"},
            "name"   => {"type" => "string", "readOnly" => true, "example" => "architecture"},
            "value"  => {"type" => "string", "readOnly" => true, "example" => "x86_64"}
          }
        },
        "Tenant" => {
          "type"       => "object",
          "properties" => {
            "id"              => {"$ref" => "##{SCHEMAS_PATH}/ID"},
            "name"            => {"type" => "string", "readOnly" => true, "example" => "Sample Tenant"},
            "description"     => {"type" => "string", "readOnly" => true, "example" => "Description of the Tenant"},
            "external_tenant" => {"type" => "string", "readOnly" => true, "example" => "External tenant identifier"}
          }
        },
      )
    end
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
      'ServiceOffering',
      'ServiceOfferingIcon',
      'ServicePlan',
      'Tag',
      'Tagging',
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
