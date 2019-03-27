require_relative "shared_examples_for_index"

RSpec.describe("v0.1 - VolumeAttachment") do
  let(:source) { Source.create!(:name => "name", :source_type => source_type, :tenant => tenant) }
  let(:source_type) { SourceType.create!(:vendor => "vendor", :product_name => "product_name", :name => "name") }
  let(:tenant) { Tenant.find_or_create_by!(:name => "default", :external_tenant => "external_tenant_uuid")}
  let(:vm) { Vm.create!("source_id" => source.id, "tenant_id" => tenant.id, "source_ref" => SecureRandom.uuid) }
  let(:volume) { Volume.create!("source_id" => source.id, "tenant_id" => tenant.id, "source_ref" => SecureRandom.uuid) }

  let(:attributes) do
    {
      "vm_id"     => vm.id.to_s,
      "volume_id" => volume.id.to_s,
      "tenant_id" => tenant.id.to_s,
    }
  end

  include_examples(
    "test_index_and_subcollections",
    "volume_attachments",
    [],
  )
end
