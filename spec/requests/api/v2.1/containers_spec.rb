require_relative "shared_examples_for_index"

RSpec.describe("v2.1 - Container") do
  include ::Spec::Support::TenantIdentity

  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
  let(:container_image)   { ContainerImage.create!(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid) }
  let(:container_group)   { ContainerGroup.create!(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid, :container_project => container_project, :container_node => container_node) }
  let(:container_node)    { ContainerNode.create!(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid) }
  let(:container_project) { ContainerProject.create!(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid) }
  let(:source)            { Source.create!(:tenant => tenant) }

  let(:attributes) do
    {
      "name"               => "name",
      "container_group_id" => container_group.id.to_s,
      "container_image_id" => container_image.id.to_s,
      "tenant_id"          => tenant.id.to_s
    }
  end

  include_examples(
    "v2x1_test_index_and_subcollections",
    "containers",
    [],
  )
end
