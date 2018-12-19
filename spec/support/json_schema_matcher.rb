RSpec::Matchers.define :match_json_schema do |version, schema|
  match do |parsed_body|
    s = Api::Docs[version].expanded_definition(schema)
    JSON::Validator.validate!(s, parsed_body)
  end
end
