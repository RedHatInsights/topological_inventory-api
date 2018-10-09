RSpec.describe Api::V1x0::SourcesController, type: :controller do
  it "delete /sources/:id deletes a Source" do
    source = Source.create!(:name => "test_source")

    delete_path(api_v1x0_source_url(source.id))

    expect { source.reload }.to raise_error(ActiveRecord::RecordNotFound)

    expect(response.status).to eq(204)
    expect(response.parsed_body).to be_empty
  end

  it "get /sources lists all Sources" do
    source = Source.create!(:name => "test_source")

    get_path(api_v1x0_sources_url)

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match([a_hash_including("id" => source.id.to_s)])
  end

  it "get /sources/:id lists all Sources" do
    source = Source.create!(:name => "test_source")

    get_path(api_v1x0_source_url(source.id))

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match(a_hash_including("id" => source.id.to_s))
  end

  it "patch /sources/:id updates a Source" do
    source = Source.create!(:name => "abc")

    patch_path(api_v1x0_source_url(source.id), :params => {:name => "xyz"})

    expect(source.reload.name).to eq("xyz")

    expect(response.status).to eq(204)
    expect(response.parsed_body).to be_empty
  end

  it "post /sources creates a Source" do
    post_path(api_v1x0_sources_url, :body => {:name => "abc"}.to_json, :format => :json)

    source = Source.first

    expect(response.status).to eq(201)
    expect(response.location).to match(a_string_ending_with("api/v1.0/sources/#{source.id}"))
    expect(JSON.parse(response.parsed_body)).to include("name" => "abc", "id" => source.id.to_s)
  end

  def delete_path(path)
    parsed_params = Rails.application.routes.recognize_path(path, :method => "DELETE")
    delete(parsed_params[:action], :params => parsed_params.except(:action, :controller))
  end

  def get_path(path)
    parsed_params = Rails.application.routes.recognize_path(path)
    get(parsed_params[:action], :params => parsed_params.except(:action, :controller))
  end

  def patch_path(path, params)
    parsed_params = Rails.application.routes.recognize_path(path, :method => "PATCH")
    patch(parsed_params[:action], :params => params[:params].merge(parsed_params.except(:action, :controller)))
  end

  def post_path(path, options)
    parsed_params = Rails.application.routes.recognize_path(path, :method => "POST")
    post(parsed_params[:action], options)
  end
end
