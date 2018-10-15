RSpec.describe Api::V0x0::ContainerNodesController, type: :controller do
  let(:project) { ContainerProject.create!(:source => source, :tenant => tenant, :name => "test_container_project") }
  let(:source) { Source.create!(:tenant => tenant) }
  let(:tenant) { Tenant.create! }
  let!(:node) { ContainerNode.create!(:source => source, :tenant => tenant, :name => "test_container_node") }

  it "get /container_nodes lists all Container Nodes" do
    get_path(api_v0x0_container_nodes_url)

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match([a_hash_including("id" => node.id.to_s)])
  end

  it "get /container_nodes/:id returns a Container Group" do
    get_path(api_v0x0_container_node_url(node.id))

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match(a_hash_including("id" => node.id.to_s))
  end
end
