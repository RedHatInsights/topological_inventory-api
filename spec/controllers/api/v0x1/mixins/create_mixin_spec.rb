describe Api::V0x1::Mixins::CreateMixin do
  describe Api::V0x1::SourcesController, :type => :request do
    it "extra body parameters raise an error" do
      post(api_v0x1_sources_url, :params => {"name" => "abc", "garbage" => "not accepted"}.to_json)

      expect(response.status).to eq(400)
      expect(response.parsed_body).to eq(
        "errors" => [
          {"detail" => "found unpermitted parameter: :garbage in POST body", "status" => "400"}
        ]
      )
    end
  end
end
