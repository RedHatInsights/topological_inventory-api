require 'manageiq/api/common/open_api/generator'
class OpenapiGenerator < ManageIQ::API::Common::OpenApi::Generator
  def build_paths
    applicable_rails_routes.each_with_object({}) do |route, expected_paths|
      without_format = route.path.split("(.:format)").first
      sub_path = without_format.split(base_path).last.sub(/:[_a-z]*id/, "{id}")
      klass_name = route.controller.split("/").last.camelize.singularize
      verb = route.verb.downcase
      primary_collection = sub_path.split("/")[1].camelize.singularize

      expected_paths[sub_path] ||= {}
      expected_paths[sub_path][verb] =
        case route.action
          when "index"   then openapi_list_description(klass_name, primary_collection)
          when "show"    then openapi_show_description(klass_name)
          when "destroy" then openapi_destroy_description(klass_name)
          when "create"  then openapi_create_description(klass_name)
          when "update"  then openapi_update_description(klass_name, verb)
          else                handle_custom_route_action(route.action.camelize, verb, primary_collection)
        end

      unless expected_paths[sub_path][verb]
        # If it's not generic action but a custom method like e.g. `post "order", :to => "service_plans#order"`, we will
        # try to take existing schema, because the description, summary, etc. are likely to be custom.
        expected_paths[sub_path][verb] =
          case verb
          when "post"
            if sub_path == "/graphql" && route.action == "query"
              schemas["GraphQLResponse"] = ::ManageIQ::API::Common::GraphQL.openapi_graphql_response
              ::ManageIQ::API::Common::GraphQL.openapi_graphql_description
            else
              openapi_contents.dig("paths", sub_path, verb) || openapi_create_description(klass_name)
            end
          when "get"
            openapi_contents.dig("paths", sub_path, verb) || openapi_show_description(klass_name)
          else
            openapi_contents.dig("paths", sub_path, verb)
          end
      end
    end
  end

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
