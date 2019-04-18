RSpec.describe("v1.0 - Authentications") do
  include ::Spec::Support::TenantIdentity

  let(:headers)         { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
  let(:attributes)      { {"username" => "test_name", "password" => "Test Password", "tenant_id" => tenant.id.to_s, "resource_type" => "Tenant", "resource_id" => tenant.id.to_s} }
  let(:collection_path) { "/api/v1.0/authentications" }

  describe("/api/v1.0/authentications") do
    context "get" do
      it "success: empty collection" do
        get(collection_path, :headers => headers)

        expect(response).to have_attributes(
          :status => 200,
          :parsed_body => paginated_response(0, [])
        )
      end

      it "success: non-empty collection" do
        Authentication.create!(attributes)

        get(collection_path, :headers => headers)

        expect(response).to have_attributes(
          :status => 200,
          :parsed_body => paginated_response(1, [a_hash_including(attributes.except("password"))])
        )
      end
    end

    context "post" do
      it "success: with valid body" do
        post(collection_path, :params => attributes.to_json, :headers => headers)

        expect(response).to have_attributes(
          :status => 201,
          :location => "http://www.example.com/api/v1.0/authentications/#{response.parsed_body["id"]}",
          :parsed_body => a_hash_including(attributes.except("password"))
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

  describe("/api/v1.0/authentications/:id") do
    def instance_path(id)
      File.join(collection_path, id.to_s)
    end

    context "get" do
      it "success: with a valid id" do
        instance = Authentication.create!(attributes)

        get(instance_path(instance.id), :headers => headers)

        expect(response).to have_attributes(
          :status => 200,
          :parsed_body => attributes.except("password").merge("id" => instance.id.to_s)
        )
      end

      it "failure: with an invalid id" do
        instance = Authentication.create!(attributes)

        missing_id = instance.id * 1000
        get(instance_path(missing_id), :headers => headers)

        expect(response).to have_attributes(
          :status => 404,
          :parsed_body => {"errors"=>[{"detail"=>"Record not found", "status"=>404}]}
        )
      end
    end
  end
end
