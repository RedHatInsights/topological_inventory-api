RSpec.describe Api::V0x0::ContainerProjectsController, :type => :request do
  it("Uses IndexMixin") { expect(described_class.instance_method(:index).owner).to eq(Api::Mixins::IndexMixin) }

  let(:source) { Source.create!(:tenant => tenant) }
  let(:tenant) { Tenant.create! }

  it "get /container_projects/:id returns a Container Project" do
    project = ContainerProject.create!(:tenant => tenant, :source => source, :name => "test_container_project")

    get(api_v0x0_container_project_url(project.id))

    expect(response.status).to eq(200)
    expect(response.parsed_body).to match(a_hash_including("id" => project.id.to_s))
  end
end
