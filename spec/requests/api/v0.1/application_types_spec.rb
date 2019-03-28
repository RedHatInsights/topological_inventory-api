require_relative "shared_examples_for_index"

RSpec.describe("v0.1 - ApplicationType") do
  let(:attributes) do
    {
      "name"         => "/hello/world",
      "display_name" => "My First Program!",
    }
  end

  include_examples(
    "test_index_and_subcollections",
    "application_types",
    [],
  )
end
