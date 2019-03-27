require_relative "shared_examples_for_index"

RSpec.describe("v0.1 - Task") do
  let(:tenant)            { Tenant.find_or_create_by!(:name => "default", :external_tenant => "external_tenant_uuid")}

  let(:attributes) do
    {
      "name"               => "name",
      "state"              => "pending",
      "status"             => "ok",
      "tenant_id"          => tenant.id.to_s
    }
  end

  include_examples(
    "test_index_and_subcollections",
    "tasks",
    [],
  )
end
