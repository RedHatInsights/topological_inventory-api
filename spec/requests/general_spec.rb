RSpec.shared_examples "invalid_url_requests" do |request_type, invalid_url|
  include ::Spec::Support::TenantIdentity

  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }

  context "with invalid #{request_type} URLs" do
    it "fail with an error object" do
      get(invalid_url, :headers => headers)

      expect(response).to have_attributes(
        :status      => 404,
        :parsed_body => {"errors" => [{"detail" => "Invalid URL #{invalid_url} specified.", "status" => 404}]}
      )
    end
  end
end

RSpec.describe("Requests") do
  include_examples("invalid_url_requests", "api", "/api/v9999/bogus_collection")
  include_examples("invalid_url_requests", "internal", "/internal/v9999/unpublished_collection")
  include_examples("invalid_url_requests", "", "/bogus_url")
end
