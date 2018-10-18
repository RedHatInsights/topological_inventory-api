describe Api::Mixins::ShowMixin do
  describe Api::V0x0::SourcesController, :type => :request do
    let!(:tenant)  { Tenant.create! }
    let!(:source_1) { Source.create!(:tenant => tenant, :name => "test_source 1") }
    let!(:source_2) { Source.create!(:tenant => tenant, :name => "test_source 2") }

    it "Primary Collection: get /sources lists all Sources" do
      get(api_v0x0_source_url(source_1.id))

      expect(response.status).to eq(200)
      expect(response.parsed_body).to include("id" => source_1.id.to_s, "name" => source_1.name)
    end

    context "Sub-collection:" do
      let!(:endpoint_1) { Endpoint.create!(:role => "a", :source => source_1, :tenant => tenant) }

      it "get /sources/:id/endpoints/:id doesn't exist" do
        get(api_v0x0_source_endpoints_url(source_1.id) + "/#{endpoint_1.id}")

        expect(response.status).to eq(404)
      end
    end
  end
end
