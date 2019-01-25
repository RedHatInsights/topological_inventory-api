RSpec.describe ApplicationController, :type => :request do

  let(:tenant)          { Tenant.create!(:external_tenant => external_tenant) }
  let(:source_type)     { SourceType.create!(:name => "openshift", :product_name => "OpenShift", :vendor => "Red Hat") }
  let(:source)          { Source.create!(:source_type_id => source_type.id, :tenant_id => tenant.id , :name => "abc", :uid => "123") }
  let(:external_tenant) { rand(1000).to_s }
  let(:identity)        { Base64.encode64({'identity' => { 'account_number' => external_tenant}}.to_json) }

  context "with tenancy enforcement" do
    before { stub_const("ENV", "ENFORCE_TENANCY" => "true") }
    after  { controller.send(:set_current_tenant,  nil) }

    it "get /source with tenant" do
      headers = { "CONTENT_TYPE" => "application/json", "x-rh-identity" => identity }

      get("/api/v0.0/sources/#{source.id}", :headers => headers)

      expect(response.status).to eq(200)
      expect(response.parsed_body).to include("id" => source.id.to_s)
    end

    it "get /source without tenant" do
      headers = { "CONTENT_TYPE" => "application/json" }

      get("/api/v0.0/sources/#{source.id}", :headers => headers)

      expect(response.status).to eq(401)
    end

    it "get /sources with tenant" do
      source
      headers = { "CONTENT_TYPE" => "application/json", "x-rh-identity" => identity }

      get("/api/v0.0/sources", :headers => headers)

      expect(response.status).to eq(200)
    end

    it "get /sources without tenant" do
      headers = { "CONTENT_TYPE" => "application/json" }

      get("/api/v0.0/sources", :headers => headers)

      expect(response.status).to eq(401)
    end
  end

  context "without tenancy enforcement" do
    after { controller.send(:set_current_tenant,  nil) }

    it "get /sources" do
      headers = { "CONTENT_TYPE" => "application/json" }

      get("/api/v0.0/sources", :headers => headers)

      expect(response.status).to eq(200)
    end
  end
end
