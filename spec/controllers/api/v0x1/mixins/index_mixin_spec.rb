describe Api::V0x1::Mixins::IndexMixin do
  describe Api::V0x1::SourcesController, :type => :request do
    include ::Spec::Support::TenantIdentity

    let(:headers)      { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
    let!(:source_1)    { Source.create!(:tenant => tenant, :name => "test_source 1", :uid => SecureRandom.uuid) }
    let!(:source_2)    { Source.create!(:tenant => tenant, :name => "test_source 2", :uid => SecureRandom.uuid) }

    it "Primary Collection: get /sources lists all Sources" do
      get(api_v0x1_sources_url, :headers => headers)

      expect(response.status).to eq(200)
      expect(response.parsed_body["data"]).to match([a_hash_including("id" => source_1.id.to_s), a_hash_including("id" => source_2.id.to_s)])
    end

    context "Sub-collection:" do
      let!(:vm_1) { Vm.create!(:source => source_1, :tenant => tenant, :source_ref => SecureRandom.uuid) }
      let!(:vm_2) { Vm.create!(:source => source_1, :tenant => tenant, :source_ref => SecureRandom.uuid) }
      let!(:vm_3) { Vm.create!(:source => source_2, :tenant => tenant, :source_ref => SecureRandom.uuid) }

      it "get /sources/:id/vms lists all Vms for a source" do
        get(api_v0x1_source_vms_url(source_1.id), :headers => headers)

        expect(response.status).to eq(200)
        expect(response.parsed_body["data"]).to match([a_hash_including("id" => vm_1.id.to_s), a_hash_including("id" => vm_2.id.to_s)])
      end
    end

    context "paging" do
      it "response_structure" do
        get(api_v0x1_sources_url, :headers => headers)

        expect(response.status).to eq(200)
        expect(response.parsed_body.keys).to eq(["meta", "links", "data"])
      end

      it "meta/count" do
        get(api_v0x1_sources_url, :headers => headers)

        expect(response.status).to eq(200)
        expect(response.parsed_body["meta"]).to eq("count" => 2, "limit" => 100, "offset" => 0)
      end
    end
  end
end
