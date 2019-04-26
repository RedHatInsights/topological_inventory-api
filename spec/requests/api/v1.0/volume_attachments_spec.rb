require_relative "shared_examples_for_index"

RSpec.describe("v1.0 - VolumeAttachment") do
  include ::Spec::Support::TenantIdentity

  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
  let(:source) { Source.create!(:tenant => tenant) }
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
    "v1x0_test_index_and_subcollections",
    "volume_attachments",
    [],
  )
end
