RSpec.describe("CFME manifest") do
  include ::Spec::Support::TenantIdentity

  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }

  describe("/cfme/manifest") do
    it "gets a specific version" do
      get("/api/cfme/manifest/5.11", :headers => headers)
      expect(response).to have_attributes(
        :status      => 200,
        :parsed_body => JSON.parse(Rails.root.join("config", "cfme", "manifest_5_11.json").read)
      )
    end

    it "disallows invalid versions" do
      get("/api/cfme/manifest/5.99", :headers => headers)
      expect(response.status).to eq 404
    end

    it "disallows nonsense versions" do
      get("/api/cfme/manifest/nonsense", :headers => headers)
      expect(response.status).to eq 404
    end
  end
end
