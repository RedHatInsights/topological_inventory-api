require_relative "shared_examples_for_index"

RSpec.describe("v2.0 - Task") do
  include ::Spec::Support::TenantIdentity

  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }

  let(:attributes) do
    {
      "name"               => "name",
      "state"              => "pending",
      "status"             => "ok",
      "tenant_id"          => tenant.id.to_s
    }
  end

  include_examples(
    "v2x0_test_index_and_subcollections",
    "tasks",
    [],
  )
end
