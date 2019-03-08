require_relative "shared_examples_for_index"

RSpec.describe("v0.1 - SourceTypes") do
  let(:attributes)      { {"name" => "test_name", "product_name" => "Test Product", "vendor" => "TestVendor"} }
  let(:collection_path) { "/api/v0.1/source_types" }

  include_examples(
    "test_index_and_subcollections",
    "source_types",
    ["availabilities", "sources"],
  )

  describe("/api/v0.1/source_types") do
    context "post" do
      it "success: with valid body" do
        post(collection_path, :params => attributes.to_json)

        expect(response).to have_attributes(
          :status => 201,
          :location => "http://www.example.com/api/v0.1/source_types/#{response.parsed_body["id"]}",
          :parsed_body => a_hash_including(attributes)
        )
      end

      it "failure: with no body" do
        post(collection_path)

        expect(response).to have_attributes(
          :status => 400,
          :location => nil,
          :parsed_body => TopologicalInventory::Api::ErrorDocument.new.add(400, "Failed to parse POST body, expected JSON")
        )
      end

      it "failure: with extra attributes" do
        post(collection_path, :params => attributes.merge("aaa" => "bbb").to_json)

        expect(response).to have_attributes(
          :status => 400,
          :location => nil,
          :parsed_body => TopologicalInventory::Api::ErrorDocument.new.add(400, "found unpermitted parameter: :aaa")
        )
      end
    end
  end
end
