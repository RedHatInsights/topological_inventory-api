require "erb"

module GraphqlGenerator
  PARAMETERS_PATH = "/components/parameters".freeze
  SCHEMAS_PATH = "/components/schemas".freeze

  def self.path_parts(openapi_path)
    openapi_path.split("/")[1..-1]
  end

  def self.graphql_schema_file
    Pathname.new(__dir__).join("../../lib/api/graphql.rb").to_s
  end

  def self.template(type)
    File.read(Pathname.new(__dir__).join("../../lib/tasks/templates/#{type}.erb").to_s)
  end

  def self.graphql_type(format, type)
    case type
    when "string"
      format == "date-time" ? "Types::DateTime" : "types.String"
    when "number"
      "types.Float"
    when "boolean"
      "types.Boolean"
    when "integer"
      "Types::BigInt"
    end
  end

  def self.generate(openapi_content)
    graphql_model_types = ""

    resources = openapi_content["paths"].keys.sort
    collections = []
    resources.each do |resource|
      next unless openapi_content.dig("paths", resource, "get") # we only care for queries

      rmatch = resource.match("^/(.*)/{id}$")
      next unless rmatch

      collection = rmatch[1]
      klass_name = collection.camelize.singularize
      this_schema = openapi_content.dig(*path_parts(SCHEMAS_PATH), klass_name)
      next if this_schema["type"] != "object" || this_schema["properties"].nil?

      graphql_model_types << "\n" unless collections.empty?

      collections << collection

      model_properties = []
      properties = this_schema["properties"]
      properties.keys.sort.each do |property_name|
        property_schema = properties[property_name]
        property_schema = openapi_content.dig(*path_parts(property_schema["$ref"])) if property_schema["$ref"]
        format       = property_schema["format"] || ""
        type         = property_schema["type"]
        graphql_type = graphql_type(format, type)
        description  = property_schema["description"]
        model_properties << [property_name, graphql_type(format, type), description] if graphql_type
      end
      graphql_model_types << ERB.new(template("model_type"), nil, '<>').result(binding) # uses klass_name and model_properties
    end
    graphql_query_type = ERB.new(template("query_type"), nil, '<>').result(binding)
    graphql_schema = ERB.new(template("graphql"), nil, '<>').result(binding)
    File.write(graphql_schema_file, graphql_schema)
  end
end
