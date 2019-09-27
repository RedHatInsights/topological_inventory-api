require_relative "shared_examples_for_index"

RSpec.describe("v1.0 - Tag") do
  include ::Spec::Support::TenantIdentity

  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }

  let(:attributes) do
    {
      "tenant_id" => tenant.id.to_s,
      "name"      => SecureRandom.uuid
    }
  end

  include_examples(
    "v1x0_test_index_and_subcollections",
    "tags",
    [
      :container_groups,
      :container_images,
      :container_nodes,
      :container_projects,
      :container_templates,
      :ipaddresses,
      :network_adapters,
      :networks,
      :security_groups,
      :service_inventories,
      :service_offerings,
      :subnets,
      :vms,
    ],
  )
end
