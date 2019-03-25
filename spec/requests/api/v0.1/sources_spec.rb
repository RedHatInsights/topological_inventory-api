require_relative "shared_examples_for_index"

RSpec.describe("v0.0 - Sources") do
  let(:attributes)      { {"name" => "my source", "source_type_id" => source_type.id.to_s, "tenant_id" => tenant.id.to_s} }
  let(:collection_path) { "/api/v0.1/sources" }
  let(:source_type)     { SourceType.create!(:name => "SourceType", :vendor => "Some Vendor", :product_name => "Product Name") }
  let(:tenant)          { Tenant.create! }

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
      "endpoints",
      "orchestration_stacks",
      "service_instances",
      "service_offerings",
      "service_plans",
      "vms",
      "volume_types",
      "volumes",
    ],
  )

  describe("/api/v0.1/sources") do
    context "post" do
      it "success: with valid body" do
        post(collection_path, :params => attributes.to_json)

        expect(response).to have_attributes(
          :status => 201,
          :location => "http://www.example.com/api/v0.1/sources/#{response.parsed_body["id"]}",
          :parsed_body => a_hash_including(attributes)
        )
      end

      it "failure: with no body" do
        post(collection_path)

        expect(response).to have_attributes(
          :status => 400,
          :location => nil,
          :parsed_body => TopologicalInventory::Api::ErrorDocument.new.add(400, "Failed to parse POST body, expected JSON").to_h
        )
      end

      it "failure: with extra attributes" do
        post(collection_path, :params => attributes.merge("aaa" => "bbb").to_json)

        expect(response).to have_attributes(
          :status => 400,
          :location => nil,
          :parsed_body => TopologicalInventory::Api::ErrorDocument.new.add(400, "found unpermitted parameter: :aaa").to_h
        )
      end
    end
  end

  describe("/api/v0.1/sources/:id") do
    def instance_path(id)
      File.join(collection_path, id.to_s)
    end

    context "patch" do
      it "success: with a valid id" do
        instance = Source.create!(attributes)
        new_attributes = {"name" => "new name"}

        patch(instance_path(instance.id), :params => new_attributes.to_json)

        expect(response).to have_attributes(
          :status => 204,
          :parsed_body => ""
        )

        expect(instance.reload).to have_attributes(new_attributes)
      end

      it "failure: with an invalid id" do
        instance = Source.create!(attributes)
        new_attributes = {"name" => "new name"}

        missing_id = instance.id * 1000
        patch(instance_path(missing_id), :params => new_attributes.to_json)

        expect(response).to have_attributes(
          :status => 404,
          :parsed_body => {"errors"=>[{"detail"=>"Couldn't find Source with 'id'=#{missing_id}", "status"=>404}]}
        )
      end

      it "failure: with extra parameters" do
        instance = Source.create!(attributes)
        new_attributes = {"aaaaa" => "bbbbb"}

        patch(instance_path(instance.id), :params => new_attributes.to_json)

        expect(response).to have_attributes(
          :status => 400,
          :parsed_body => {"errors" => [{"detail"=>"found unpermitted parameter: :aaaaa", "status" => 400}]}
        )
      end

      it "failure: with read-only parameters" do
        instance = Source.create!(attributes)
        new_attributes = {"uid" => "xxxxx"}

        patch(instance_path(instance.id), :params => new_attributes.to_json)

        expect(response).to have_attributes(
          :status => 400,
          :parsed_body => {"errors" => [{"detail"=>"found unpermitted parameter: :uid", "status" => 400}]}
        )
      end
    end
  end
end
