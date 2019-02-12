RSpec.describe Api::V0x1::SourcesController, :type => :request do
  include ::Spec::Support::TenantIdentity

  it("Uses CreateMixin")  { expect(described_class.instance_method(:create).owner).to eq(Api::V0x1::Mixins::CreateMixin) }
  it("Uses DestroyMixin") { expect(described_class.instance_method(:destroy).owner).to eq(Api::V0x1::Mixins::DestroyMixin) }
  it("Uses IndexMixin")   { expect(described_class.instance_method(:index).owner).to eq(Api::V0x1::Mixins::IndexMixin) }
  it("Uses ShowMixin")    { expect(described_class.instance_method(:show).owner).to eq(Api::V0::Mixins::ShowMixin) }
  it("Uses UpdateMixin")  { expect(described_class.instance_method(:update).owner).to eq(Api::V0x1::Mixins::UpdateMixin) }

  let(:source_type) { SourceType.create!(:name => "openshift", :product_name => "OpenShift", :vendor => "Red Hat") }

  it "post /sources creates a Source" do
    headers = { "CONTENT_TYPE" => "application/json", "x-rh-identity" => identity }
    post(api_v0x1_sources_url, :headers => headers, :params => {:source_type_id => source_type.id.to_s, :tenant_id => tenant.id.to_s, :name => "abc"}.to_json)

    source = Source.first

    expect(response.status).to eq(201)
    expect(response.location).to match(a_string_ending_with("v0.1/sources/#{source.id}"))
    expect(response.parsed_body).to include("name" => "abc", "id" => source.id.to_s)
  end
end
