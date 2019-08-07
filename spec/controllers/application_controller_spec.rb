RSpec.describe ApplicationController, :type => :request do
  include ::Spec::Support::TenantIdentity
  let!(:source)     { Source.create!(:tenant_id => tenant.id , :uid => "123") }

  context "with tenancy enforcement" do
    before { stub_const("ENV", "BYPASS_TENANCY" => nil) }

    it "get /source with tenant" do
      headers = {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity}

      get("/api/v1.0/sources/#{source.id}", :headers => headers)

      expect(response.status).to eq(200)
      expect(response.parsed_body).to include("id" => source.id.to_s)
    end

    it "get /source with unknown tenant" do
      headers = {"CONTENT_TYPE" => "application/json", "x-rh-identity" => unknown_identity}

      get("/api/v1.0/sources/#{source.id}", :headers => headers)

      expect(response.status).to eq(404)
      expect(Tenant.find_by(:external_tenant => unknown_tenant)).not_to be_nil
    end

    it "get /sources with tenant" do
      headers = {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity}

      get("/api/v1.0/sources", :headers => headers)

      expect(response.status).to eq(200)
    end

    it "get /sources with unknown tenant" do
      headers = {"CONTENT_TYPE" => "application/json", "x-rh-identity" => unknown_identity}

      get("/api/v1.0/sources", :headers => headers)

      expect(response.status).to eq(200)
      expect(Tenant.find_by(:external_tenant => unknown_tenant)).not_to be_nil
    end

    it "get /sources with no identity" do
      headers = {"CONTENT_TYPE" => "application/json"}

      get("/api/v1.0/sources", :headers => headers)

      expect(response.status).to eq(401)
    end
  end

  context "without tenancy enforcement" do
    before { stub_const("ENV", "BYPASS_TENANCY" => "true") }

    it "get /sources without identity" do
      headers = {"CONTENT_TYPE" => "application/json"}

      get("/api/v1.0/sources", :headers => headers)

      expect(response.status).to eq(200)
    end

    it "get /sources with unknown identity" do
      headers = {"CONTENT_TYPE" => "application/json", "x-rh-identity" => unknown_identity}

      get("/api/v1.0/sources", :headers => headers)

      expect(response.status).to eq(200)
    end
  end

  context "with entitlement" do
    let(:entitlements) do
      {
        "hybrid_cloud" => {
            "is_entitled" => true
        },
        "insights"     => {
            "is_entitled" => true
        }
      }
    end

    it "permits request with all the necessary entitlements" do
      headers = {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity_with_entitlements}

      get("/api/v1.0/sources", :headers => headers)

      expect(response.status).to eq(200)
    end

    it "permits request with one of the necessary entitlements" do
      entitlements["insights"]["is_entitled"] = false

      headers = {
          "CONTENT_TYPE"  => "application/json",
          "x-rh-identity" => Base64.encode64(
            {'identity' => {'account_number' => external_tenant}, :entitlements => entitlements}.to_json
          )
      }

      get("/api/v1.0/sources", :headers => headers)

      expect(response.status).to eq(200)
    end

    it "forbids request with none of the necessary entitlements" do
      entitlements["insights"]["is_entitled"]     = false
      entitlements["hybrid_cloud"]["is_entitled"] = false

      headers = {
          "CONTENT_TYPE"  => "application/json",
          "x-rh-identity" => Base64.encode64(
            {'identity' => {'account_number' => external_tenant}, :entitlements => entitlements}.to_json
          )
      }

      get("/api/v1.0/sources", :headers => headers)

      expect(response.status).to eq(403)
    end
  end
end
