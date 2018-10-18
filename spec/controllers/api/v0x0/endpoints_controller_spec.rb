RSpec.describe Api::V0x0::EndpointsController, :type => :request do
  it("Uses DestroyMixin") { expect(described_class.instance_method(:destroy).owner).to eq(Api::Mixins::DestroyMixin) }
  it("Uses IndexMixin")   { expect(described_class.instance_method(:index).owner).to eq(Api::Mixins::IndexMixin) }
  it("Uses ShowMixin")    { expect(described_class.instance_method(:show).owner).to eq(Api::Mixins::ShowMixin) }

  let(:source) { Source.create!(:tenant => tenant) }
  let(:tenant) { Tenant.create! }

  it "patch /endpoints/:id updates an Endpoint" do
    endpoint = Endpoint.create!(:source => source, :tenant => tenant, :host => "example.com")

    patch(api_v0x0_endpoint_url(endpoint.id), :params => {:host => "example.org"})

    expect(endpoint.reload.host).to eq("example.org")

    expect(response.status).to eq(204)
    expect(response.parsed_body).to be_empty
  end

  it "post /endpoints creates an Endpoint" do
    headers = { "CONTENT_TYPE" => "application/json" }
    post(api_v0x0_endpoints_url, :params => {:host => "example.com", :source_id => source.id.to_s, :tenant_id => tenant.id.to_s}.to_json)

    endpoint = Endpoint.first

    expect(response.status).to eq(201)
    expect(response.location).to match(a_string_ending_with("api/v0.0/endpoints/#{endpoint.id}"))
    expect(response.parsed_body).to include("host" => "example.com", "id" => endpoint.id.to_s)
  end
end
