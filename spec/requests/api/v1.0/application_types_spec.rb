require_relative "shared_examples_for_index"

RSpec.describe("v1.0 - ApplicationType") do
  include ::Spec::Support::TenantIdentity

  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
  let(:attributes) do
    {
      "name"         => "/hello/world",
      "display_name" => "My First Program!",
    }
  end

  include_examples(
    "v1x0_test_index_and_subcollections",
    "application_types",
    [],
  )
end
