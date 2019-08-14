require_relative "shared_examples_for_index"

RSpec.describe("v1.0 - SourceRegion") do
  include ::Spec::Support::TenantIdentity

  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
  let(:source) { Source.create!(:tenant => tenant) }

  let(:attributes) do
    {
      "source_id"  => source.id.to_s,
      "tenant_id"  => tenant.id.to_s,
      "source_ref" => SecureRandom.uuid
    }
  end

  include_examples(
    "v1x0_test_index_and_subcollections",
    "source_regions",
    [
      :ipaddresses,
      :network_adapters,
      :networks,
      :orchestration_stacks,
      :security_groups,
      :service_instances,
      :service_offerings,
      :service_plans,
      :subnets,
      :vms,
      :volumes,
    ],
  )
end
