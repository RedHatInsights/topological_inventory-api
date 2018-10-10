RSpec.describe Api::V0x0::ContainerProjectsController, type: :controller do
  it "get /container_projects lists all Container Projects" do
    project = ContainerProject.create!(:name => "test_container_project")

    get_path(api_v0x0_container_projects_url)

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match([a_hash_including("id" => project.id.to_s)])
  end

  it "get /container_projects/:id returns a Container Project" do
    project = ContainerProject.create!(:name => "test_container_project")

    get_path(api_v0x0_container_project_url(project.id))

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match(a_hash_including("id" => project.id.to_s))
  end

  def get_path(path)
    parsed_params = Rails.application.routes.recognize_path(path)
    get(parsed_params[:action], :params => parsed_params.except(:action, :controller))
  end
end
