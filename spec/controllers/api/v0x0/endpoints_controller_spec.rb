RSpec.describe Api::V0x0::EndpointsController, :type => :request do
  it("Uses DestroyMixin") { expect(described_class.instance_method(:destroy).owner).to eq(Api::Mixins::DestroyMixin) }
  it("Uses IndexMixin")   { expect(described_class.instance_method(:index).owner).to eq(Api::Mixins::IndexMixin) }
  it("Uses ShowMixin")    { expect(described_class.instance_method(:show).owner).to eq(Api::Mixins::ShowMixin) }
  it("Uses UpdateMixin")  { expect(described_class.instance_method(:update).owner).to eq(Api::Mixins::UpdateMixin) }

  let(:source)      { Source.create!(:source_type => source_type, :tenant => tenant) }
  let(:source_type) { SourceType.create!(:name => "openshift", :product_name => "OpenShift", :vendor => "Red Hat") }
  let(:tenant)      { Tenant.create! }

  it "post /endpoints creates an Endpoint" do
    headers = { "CONTENT_TYPE" => "application/json" }
    post(api_v0x0_endpoints_url, :params => {:host => "example.com", :source_id => source.id, :tenant_id => tenant.id}.to_json)

    endpoint = Endpoint.first

    expect(response.status).to eq(201)
    expect(response.location).to match(a_string_ending_with("v0.0/endpoints/#{endpoint.id}"))
    expect(response.parsed_body).to include("host" => "example.com", "id" => endpoint.id)
  end
end
