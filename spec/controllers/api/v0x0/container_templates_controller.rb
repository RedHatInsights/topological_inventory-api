RSpec.describe Api::V0x0::ContainerTemplatesController, :type => :request do
  it("Uses IndexMixin") { expect(described_class.instance_method(:index).owner).to eq(Api::Mixins::IndexMixin) }

  let(:project) { ContainerProject.create!(:source => source, :tenant => tenant, :name => "test_container_project") }
  let(:source) { Source.create!(:tenant => tenant) }
  let(:tenant) { Tenant.create! }
  let!(:template) { ContainerTemplate.create!(:source => source, :tenant => tenant, :container_project => project, :name => "test_container_template") }

  it "get /container_templates/:id returns a Container Group" do
    get(api_v0x0_container_template_url(template.id))

    expect(response.status).to eq(200)
    expect(response.parsed_body).to match(a_hash_including("id" => template.id.to_s))
  end
end
