describe Api::V0::Mixins::ShowMixin do
  describe Api::V0x1::SourcesController, :type => :request do
    include ::Spec::Support::TenantIdentity

    let(:headers)     { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
    let!(:source_1)   { Source.create!(:tenant => tenant, :uid => SecureRandom.uuid) }
    let!(:source_2)   { Source.create!(:tenant => tenant, :uid => SecureRandom.uuid) }

    it "Primary Collection: get /sources lists all Sources" do
      get(api_v0x1_source_url(source_1.id), :headers => headers)

      expect(response.status).to eq(200)
      expect(response.parsed_body).to include("id" => source_1.id.to_s, "uid" => source_1.uid)
    end

    context "Sub-collection:" do
      let!(:vm_1) { Vm.create!(:source => source_1, :tenant => tenant, :source_ref => SecureRandom.uuid) }

      it "get /sources/:id/vms/:id doesn't exist" do
        get(api_v0x1_source_vms_url(source_1.id) + "/#{vm_1.id}", :headers => headers)

        expect(response.status).to eq(404)
      end
    end
  end
end
