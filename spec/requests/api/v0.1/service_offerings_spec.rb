require_relative "shared_examples_for_index"

RSpec.describe("v0.1 - ServiceOffering") do
  let(:source) { Source.create!(:name => "name", :source_type => source_type, :tenant => tenant) }
  let(:source_type) { SourceType.create!(:vendor => "vendor", :product_name => "product_name", :name => "name") }
  let(:tenant) { Tenant.create! }
  let(:source_region) { Tenant.create! }
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
