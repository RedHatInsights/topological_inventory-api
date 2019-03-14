RSpec.describe ApplicationController, :type => :request do
  include ::Spec::Support::TenantIdentity
  let!(:source)     { Source.create!(:tenant_id => tenant.id , :uid => "123") }

  context "with tenancy enforcement" do
    before { stub_const("ENV", "BYPASS_TENANCY" => nil) }

    it "get /source with tenant" do
      headers = { "CONTENT_TYPE" => "application/json", "x-rh-identity" => identity }

      get("/api/v1.0/sources/#{source.id}", :headers => headers)

      expect(response.status).to eq(200)
      expect(response.parsed_body).to include("id" => source.id.to_s)
    end

    it "get /source with unknown tenant" do
      headers = { "CONTENT_TYPE" => "application/json", "x-rh-identity" => unknown_identity }

      get("/api/v1.0/sources/#{source.id}", :headers => headers)

      expect(response.status).to eq(404)
      expect(Tenant.find_by(:external_tenant => unknown_tenant)).not_to be_nil
    end

    it "get /sources with tenant" do
      headers = { "CONTENT_TYPE" => "application/json", "x-rh-identity" => identity }

      get("/api/v1.0/sources", :headers => headers)

      expect(response.status).to eq(200)
    end

    it "get /sources with unknown tenant" do
      headers = { "CONTENT_TYPE" => "application/json", "x-rh-identity" => unknown_identity }

      get("/api/v1.0/sources", :headers => headers)

      expect(response.status).to eq(200)
      expect(Tenant.find_by(:external_tenant => unknown_tenant)).not_to be_nil
    end

    it "get /sources with no identity" do
      headers = { "CONTENT_TYPE" => "application/json" }

      get("/api/v1.0/sources", :headers => headers)

      expect(response.status).to eq(401)
    end
  end

  context "without tenancy enforcement" do
    before { stub_const("ENV", "BYPASS_TENANCY" => "true") }

    it "get /sources without identity" do
      headers = { "CONTENT_TYPE" => "application/json" }

      get("/api/v1.0/sources", :headers => headers)

      expect(response.status).to eq(200)
    end

    it "get /sources with unknown identity" do
      headers = { "CONTENT_TYPE" => "application/json", "x-rh-identity" => unknown_identity }

      get("/api/v1.0/sources", :headers => headers)

      expect(response.status).to eq(200)
    end
  end
end
