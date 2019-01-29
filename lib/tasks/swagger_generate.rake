class SwaggerGenerator
  def rails_routes
    Rails.application.routes.routes.each_with_object([]) do |route, array|
      r = ActionDispatch::Routing::RouteWrapper.new(route)
      next if r.internal? # Don't display rails routes
      next if r.engine? # Don't care right now...

      array << r
    end
  end

  def swagger_file
    Pathname.new(__dir__).join("../../public/doc/swagger-2-v0.1.0.yaml").to_s
  end

  def swagger_contents
    @swagger_contents ||= begin
      require 'yaml'
      content = File.read(swagger_file).tap { |c| c.gsub!("- null", "- NULL VALUE") }
      YAML.load(content)
    end
  end

  def initialize
    app_prefix, app_name = base_path.match(/\A(.*)\/(.*)\/v\d+.\d+\z/).captures
    ENV['APP_NAME'] = app_name
    ENV['PATH_PREFIX'] = app_prefix
    Rails.application.reload_routes!
  end

  def base_path
    swagger_contents["basePath"]
  end

  def applicable_rails_routes
    rails_routes.select { |i| i.path.start_with?(base_path) }
  end

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
          when "index"   then swagger_list_description(klass_name, primary_collection)
          when "show"    then swagger_show_description(klass_name)
          when "destroy" then swagger_destroy_description(klass_name)
          when "create"  then swagger_create_description(klass_name)
          when "update"  then swagger_update_description(klass_name, verb)
        end
    end
  end

  def definitions
    @definitions ||= {}
  end

  def build_definition(name, value = nil)
    definitions[name] = value
    "#/definitions/#{name}"
  end

  def parameters
    @parameters ||= {}
  end

  def build_parameter(name, value = nil)
    parameters[name] = value
    "#/parameters/#{name}"
  end

  def swagger_list_description(klass_name, primary_collection)
    primary_collection = nil if primary_collection == klass_name
    {
      "summary" => "List #{klass_name.pluralize}#{" for #{primary_collection}" if primary_collection}",
      "operationId" => "list#{primary_collection}#{klass_name.pluralize}",
      "description" => "Returns an array of #{klass_name} objects",
      "parameters" => [
        {"$ref" => "#/parameters/QueryLimit"},
        {"$ref" => "#/parameters/QueryOffset"}
      ],
      "produces" => ["application/json"],
      "responses" => {
        200 => {
          "description" => "#{klass_name.pluralize} collection",
          "schema" => {"$ref" => build_collection_definition(klass_name)}
        }
      }
    }.tap do |h|
      h["parameters"] << {"$ref" => build_parameter("ID")} if primary_collection
    end
  end

  def build_collection_definition(klass_name)
    collection_name = "#{klass_name.pluralize}Collection"
    definitions[collection_name] = {
      "type" => "object",
      "properties" => {
        "meta" => {"$ref" => "#/definitions/CollectionMetadata"},
        "links" => {"$ref" => "#/definitions/CollectionLinks"},
        "data" => {
          "type" => "array",
          "items" => {"$ref" => build_definition(klass_name)}
        }
      }
    }

    "#/definitions/#{collection_name}"
  end

  def swagger_show_description(klass_name)
    {
      "summary" => "Show an existing #{klass_name}",
      "operationId" => "show#{klass_name}",
      "description" => "Returns a #{klass_name} object",
      "produces" => ["application/json"],
      "parameters" => [{"$ref" => build_parameter("ID")}],
      "responses" => {
        200 => {
          "description" => "#{klass_name} info",
          "schema" => {"$ref" => build_definition(klass_name)}
        },
        404 => {"description" => "Not found"}
      }
    }
  end

  def swagger_destroy_description(klass_name)
    {
      "summary" => "Delete an existing #{klass_name}",
      "operationId" => "delete#{klass_name}",
      "description" => "Deletes a #{klass_name} object",
      "produces" => ["application/json"],
      "parameters" => [{"$ref" => build_parameter("ID")}],
      "responses" => {
        204 => {"description" => "#{klass_name} deleted"},
        404 => {"description" => "Not found"}
      }
    }
  end

  def swagger_create_description(klass_name)
    {
      "summary" => "Create a new #{klass_name}",
      "operationId" => "create#{klass_name}",
      "description" => "Creates a #{klass_name} object",
      "produces" => ["application/json"],
      "consumes" => ["application/json"],
      "parameters" => [
        {
          "name" => "body",
          "in" => "body",
          "description" => "#{klass_name} attributes to create",
          "required" => true,
          "schema" => {"$ref" => build_definition(klass_name)}
        }
      ],
      "responses" => {
        201 => {
          "description" => "#{klass_name} creation successful",
          "schema" => {
            "type" => "object",
            "items" => {"$ref" => build_definition(klass_name)}
          }
        }
      }
    }
  end

  def swagger_update_description(klass_name, verb)
    action = verb == "patch" ? "Update" : "Replace"
    {
      "summary" => "#{action} an existing #{klass_name}",
      "operationId" => "#{action.downcase}#{klass_name}",
      "description" => "#{action}s a #{klass_name} object",
      "produces" => ["application/json"],
      "consumes" => ["application/json"],
      "parameters" => [
        {"$ref" => build_parameter("ID")},
        {
          "name" => "body",
          "in" => "body",
          "description" => "#{klass_name} attributes to update",
          "required" => true,
          "schema" => {"$ref" => build_definition(klass_name)}
        }
      ],
      "responses" => {
        204 => {"description" => "Updated, no content"},
        404 => {"description" => "Not found"}
      }
    }
  end

  def run
    parameters["QueryOffset"] = {
      "in" => "query",
      "name" => "offset",
      "type" => "integer",
      "required" => false,
      "default" => 0,
      "minimum" => 0,
      "description" => "The number of items to skip before starting to collect the result set."
    }

    parameters["QueryLimit"] = {
      "in" => "query",
      "name" => "limit",
      "type" => "integer",
      "required" => false,
      "default" => 100,
      "minimum" => 1,
      "maximum" => 1000,
      "description" => "The numbers of items to return per page."
    }

    definitions["CollectionLinks"] = {
      "type" => "object",
      "properties" => {
        "first" => {
          "type" => "string"
        },
        "last"  => {
          "type" => "string"
        },
        "prev"  => {
          "type" => "string"
        },
        "next"  => {
          "type" => "string"
        }
      }
    }

    definitions["CollectionMetadata"] = {
      "type" => "object",
      "properties" => {
        "count" => {
          "type" => "integer"
        }
      }
    }

    definitions["OrderParameters"] = {
      "type" => "object",
      "properties" => {
        "service_parameters" => {
          "type" => "object",
          "description" => "JSON object with provisioning parameters"
        },
        "provider_control_parameters" => {
          "type" => "object",
          "description" => "The provider specific parameters needed to provision this service. This might include namespaces, special keys"
        }
      }
    }

    new_content = swagger_contents
    new_content["paths"] = build_paths.sort.to_h
    new_content["parameters"] = parameters.sort.each_with_object({}) { |(name, val), h| h[name] = val || swagger_contents["parameters"][name] || {} }
    new_content["definitions"] = definitions.sort.each_with_object({}) { |(name, val), h| h[name] = val || swagger_contents["definitions"][name] || {} }
    File.write(swagger_file, new_content.to_yaml(line_width: -1).sub("---\n", "").tap { |c| c.gsub!("- NULL VALUE", "- null") })
  end
end

namespace :swagger do
  desc "Generate the swagger.yml contents"
  task :generate => :environment do
    SwaggerGenerator.new.run
  end
end
