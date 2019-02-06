RSpec.describe Api::V0x0::SourceTypesController, :type => :request do
  include ::Spec::Support::TenantIdentity

  it("Uses IndexMixin")   { expect(described_class.instance_method(:index).owner).to eq(Api::V0::Mixins::IndexMixin) }
  it("Uses ShowMixin")    { expect(described_class.instance_method(:show).owner).to eq(Api::V0::Mixins::ShowMixin) }

  it "post /sources creates a Source" do
    headers = { "CONTENT_TYPE" => "application/json" }
    post(api_v0x0_source_types_url, :headers => {"x-rh-identity" => identity}, :params => {:name => "openshift", :product_name => "OpenShift", :vendor => "Red Hat"}.to_json)

    source_type = SourceType.first

    expect(response.status).to eq(201)
    expect(response.location).to match(a_string_ending_with("v0.0/source_types/#{source_type.id}"))
    expect(response.parsed_body).to include("name" => "openshift", "id" => source_type.id.to_s)
  end
end
