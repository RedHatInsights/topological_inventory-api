require_relative "shared_examples_for_index"

RSpec.describe("v0.1 - ContainerGroup") do
  let(:tenant) { Tenant.find_or_create_by!(:name => "default", :external_tenant => "external_tenant_uuid")}

  let(:attributes) do
    {
      "tenant_id" => tenant.id.to_s,
      "name"      => SecureRandom.uuid
    }
  end

  include_examples(
    "test_index_and_subcollections",
    "tags",
    ["container_groups", "container_images", "container_nodes", "container_projects", "container_templates",
     "service_offerings", "vms"],
  )
end
