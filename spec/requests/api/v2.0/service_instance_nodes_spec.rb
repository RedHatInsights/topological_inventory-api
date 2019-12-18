require_relative "shared_examples_for_index"

RSpec.describe("v2.0 - ServiceInstanceNode") do
  include ::Spec::Support::TenantIdentity

  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
  let(:source) { Source.create!(:tenant => tenant) }

  let(:attributes) do
    {
      "source_id"  => source.id.to_s,
      "tenant_id"  => tenant.id.to_s,
      "source_ref" => SecureRandom.uuid,
    }
  end

  include_examples(
    "v2x0_test_index_and_subcollections",
    "service_instance_nodes",
    [],
  )
end
