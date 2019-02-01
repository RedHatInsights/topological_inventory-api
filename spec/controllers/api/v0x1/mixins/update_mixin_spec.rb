describe Api::V0x1::Mixins::UpdateMixin do
  describe Api::V0x1::SourcesController, :type => :request do
    let(:source)      { Source.create!(:source_type => source_type, :tenant => tenant, :name => "abc", :uid => SecureRandom.uuid) }
    let(:source_type) { SourceType.create!(:name => "openshift", :product_name => "OpenShift", :vendor => "Red Hat") }
    let(:tenant)      { Tenant.create! }

    it "patch /sources/:id updates a Source" do
      patch(api_v0x1_source_url(source.id), :params => {:name => "xyz"}.to_json)

      expect(source.reload.name).to eq("xyz")

      expect(response.status).to eq(204)
      expect(response.parsed_body).to be_empty
    end

    it "extra body parameters raise an error" do
      patch(api_v0x1_source_url(source.id), :params => {"name" => "abc", "garbage" => "not accepted"}.to_json)

      expect(response.status).to eq(400)
      expect(response.parsed_body).to eq(
        "errors" => [
          {"detail" => "found unpermitted parameter: :garbage in PATCH body", "status" => "400"}
        ]
      )
    end
  end
end
