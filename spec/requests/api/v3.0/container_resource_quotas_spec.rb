require_relative "shared_examples_for_index"

RSpec.describe("v3.0 - ContainerResourceQuota") do
  include ::Spec::Support::TenantIdentity

  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
  let(:container_project) { ContainerProject.create!(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid) }
  let(:source) { Source.create!(:tenant => tenant) }

  let(:attributes) do
    {
      "container_project_id" => container_project.id.to_s,
      "source_id"            => source.id.to_s,
      "tenant_id"            => tenant.id.to_s,
      "source_ref"           => SecureRandom.uuid
    }
  end

  include_examples(
    "v3x0_test_index_and_subcollections",
    "container_resource_quotas",
    [],
  )
end
