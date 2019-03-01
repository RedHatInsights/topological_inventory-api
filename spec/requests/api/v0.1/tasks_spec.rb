require_relative "shared_examples_for_index"

RSpec.describe("v0.1 - Task") do
  let(:tenant)            { Tenant.create! }

  let(:attributes) do
    {
      "name"               => "name",
      "tenant_id"          => tenant.id.to_s
    }
  end

  include_examples(
    "test_index_and_subcollections",
    "tasks",
    [],
  )
end
