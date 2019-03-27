require_relative "shared_examples_for_index"

RSpec.describe("v0.1 - ServicePlan") do
  let(:source) { Source.create!(:name => "name", :source_type => source_type, :tenant => tenant) }
  let(:source_type) { SourceType.create!(:vendor => "vendor", :product_name => "product_name", :name => "name") }
  let(:tenant) { Tenant.find_or_create_by!(:name => "default", :external_tenant => "external_tenant_uuid")}
  let(:source_region) { Tenant.find_or_create_by!(:name => "default", :external_tenant => "external_tenant_uuid")}
  let(:subscription) { Subscription.create!("source_id" => source.id, "tenant_id" => tenant.id, "source_ref" => SecureRandom.uuid) }
  let(:source_region) { SourceRegion.create!("source_id" => source.id, "tenant_id" => tenant.id, "source_ref" => SecureRandom.uuid) }
  let(:service_offering) { ServiceOffering.create!("source_id" => source.id, "tenant_id" => tenant.id, "source_region_id" => source_region.id, "subscription_id" => subscription.id, "source_ref" => SecureRandom.uuid,) }

  let(:attributes) do
    {
      "source_id"           => source.id.to_s,
      "tenant_id"           => tenant.id.to_s,
      "source_region_id"    => source_region.id.to_s,
      "subscription_id"     => subscription.id.to_s,
      "service_offering_id" => service_offering.id.to_s,
      "source_ref"          => SecureRandom.uuid,
    }
  end

  include_examples(
    "test_index_and_subcollections",
    "service_plans",
    ["service_instances"],
  )
end
