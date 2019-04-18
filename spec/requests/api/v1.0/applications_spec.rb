require_relative "shared_examples_for_index"

RSpec.describe("v0.0 - Applications") do
  include ::Spec::Support::TenantIdentity

  let(:headers)          { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
  let(:application_type) { ApplicationType.find_or_create_by!(:name => "/hello/world", :display_name => "Hello World") }
  let(:collection_path)  { "/api/v1.0/applications" }
  let(:source)           { Source.find_or_create_by!(:name => "My Source", :tenant => tenant, :source_type => source_type) }
  let(:source_type)      { SourceType.find_or_create_by!(:name => "SourceType", :vendor => "Some Vendor", :product_name => "Product Name") }
  let(:attributes)       do
    {
      "application_type_id" => application_type.id.to_s,
      "tenant_id"           => tenant.id.to_s,
      "source_id"           => source.id.to_s
    }
  end

  include_examples(
    "v1x0_test_index_and_subcollections",
    "applications",
    []
  )

  describe "/api/v1.0/applications" do
    context "post" do
      it "success: with valid body" do
        post(collection_path, :params => attributes.to_json, :headers => headers)

        expect(response).to have_attributes(
          :status => 201,
          :location => "http://www.example.com/api/v1.0/applications/#{response.parsed_body["id"]}",
          :parsed_body => a_hash_including(attributes)
        )
      end

      it "failure: with no body" do
        post(collection_path, :headers => headers)

        expect(response).to have_attributes(
          :status => 400,
          :location => nil,
          :parsed_body => ManageIQ::API::Common::ErrorDocument.new.add(400, "Failed to parse POST body, expected JSON").to_h
        )
      end

      it "failure: with extra attributes" do
        post(collection_path, :params => attributes.merge("aaa" => "bbb").to_json, :headers => headers)

        expect(response).to have_attributes(
          :status => 400,
          :location => nil,
          :parsed_body => ManageIQ::API::Common::ErrorDocument.new.add(400, "found unpermitted parameter: :aaa").to_h
        )
      end
    end
  end
end
