RSpec.describe Api::V0x0::ContainerGroupsController, type: :controller do
  let(:project) { ContainerProject.create!(:source => source, :tenant => tenant, :name => "test_container_project") }
  let(:node) { ContainerNode.create!(:source => source, :tenant => tenant, :name => "test_container_node") }
  let(:source) { Source.create!(:tenant => tenant) }
  let(:tenant) { Tenant.create! }
  let!(:group) do
    ContainerGroup.create!(
      :tenant => tenant,
      :source => source,
      :name => "test_container_group",
      :container_project => project,
      :container_node => node)
  end

  it "get /container_groups lists all Container Groups" do
    get_path(api_v0x0_container_groups_url)

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match([a_hash_including("id" => group.id.to_s)])
  end

  it "get /container_groups/:id returns a Container Group" do
    get_path(api_v0x0_container_group_url(group.id))

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match(a_hash_including("id" => group.id.to_s))
  end
end
