require_relative "shared_examples_for_index"

RSpec.describe("v0.0 - Sources") do
  include ::Spec::Support::TenantIdentity

  let(:headers)         { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
  let(:attributes)      { {"name" => "my source", "source_type_id" => source_type.id.to_s, "tenant_id" => tenant.id.to_s} }
  let(:collection_path) { "/api/v0.1/sources" }

  include_examples(
    "test_index_and_subcollections",
    "sources",
    [
      "container_groups",
      "container_images",
      "container_nodes",
      "container_projects",
      "container_templates",
      "containers",
      "orchestration_stacks",
      "service_instances",
      "service_offerings",
      "service_plans",
      "vms",
      "volume_types",
      "volumes",
    ],
  )
end
