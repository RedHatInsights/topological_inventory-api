require_relative "shared_examples_for_index"
require_relative "shared_examples_for_tags"

RSpec.describe("v3.0 - ServiceOffering") do
  include ::Spec::Support::TenantIdentity

  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
  let(:source) { Source.create!(:tenant => tenant) }
  let(:subscription) { Subscription.create!("source_id" => source.id, "tenant_id" => tenant.id, "source_ref" => SecureRandom.uuid) }
  let(:source_region) { SourceRegion.create!("source_id" => source.id, "tenant_id" => tenant.id, "source_ref" => SecureRandom.uuid) }

  let(:attributes) do
    {
      "source_id"        => source.id.to_s,
      "tenant_id"        => tenant.id.to_s,
      "source_region_id" => source_region.id.to_s,
      "subscription_id"  => subscription.id.to_s,
      "source_ref"       => SecureRandom.uuid,
    }
  end

  include_examples(
    "v3x0_test_index_and_subcollections",
    "service_offerings",
    ["service_instances", "service_plans", "service_offering_nodes"],
  )

  include_examples("v3x0_test_tags_subcollection", "service_offerings")
end
