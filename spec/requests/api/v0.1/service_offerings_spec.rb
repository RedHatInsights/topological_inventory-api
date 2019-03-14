require_relative "shared_examples_for_index"

RSpec.describe("v0.1 - ServiceOffering") do
  include ::Spec::Support::TenantIdentity

  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
  let(:source) { Source.create!(:name => "name", :tenant => tenant) }
  let(:source_region) { Tenant.find_or_create_by!(:name => "default", :external_tenant => "external_tenant_uuid")}
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
    "test_index_and_subcollections",
    "service_offerings",
    ["tags", "service_instances", "service_plans"],
  )
end
