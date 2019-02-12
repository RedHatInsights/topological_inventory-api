RSpec.describe ApplicationController, :type => :request do
  include ::Spec::Support::TenantIdentity
  let(:source_type) { SourceType.create!(:name => "openshift", :product_name => "OpenShift", :vendor => "Red Hat") }
  let!(:source)     { Source.create!(:source_type_id => source_type.id, :tenant_id => tenant.id , :name => "abc", :uid => "123") }

  context "with tenancy enforcement" do
    before { stub_const("ENV", "BYPASS_TENANCY" => nil) }
    after  { controller.send(:set_current_tenant,  nil) }

    it "get /source with tenant" do
      headers = { "CONTENT_TYPE" => "application/json", "x-rh-identity" => identity }

      get("/api/v0.0/sources/#{source.id}", :headers => headers)

      expect(response.status).to eq(200)
      expect(response.parsed_body).to include("id" => source.id.to_s)
    end

    it "get /source with unknown tenant" do
      headers = { "CONTENT_TYPE" => "application/json", "x-rh-identity" => unknown_identity }

      get("/api/v0.0/sources/#{source.id}", :headers => headers)

      expect(response.status).to eq(401)
    end

    it "get /sources with tenant" do
      headers = { "CONTENT_TYPE" => "application/json", "x-rh-identity" => identity }

      get("/api/v0.0/sources", :headers => headers)

      expect(response.status).to eq(200)
    end

    it "get /sources with unknown tenant" do
      headers = { "CONTENT_TYPE" => "application/json", "x-rh-identity" => unknown_identity }

      get("/api/v0.0/sources", :headers => headers)

      expect(response.status).to eq(401)
    end
  end

  context "without tenancy enforcement" do
    before { stub_const("ENV", "BYPASS_TENANCY" => "true") }
    after { controller.send(:set_current_tenant,  nil) }

    it "get /sources without identity" do
      headers = { "CONTENT_TYPE" => "application/json" }

      get("/api/v0.0/sources", :headers => headers)

      expect(response.status).to eq(200)
    end

    it "get /sources with unknown identity" do
      headers = { "CONTENT_TYPE" => "application/json", "x-rh-identity" => unknown_identity }

      get("/api/v0.0/sources", :headers => headers)

      expect(response.status).to eq(200)
    end
  end
end
