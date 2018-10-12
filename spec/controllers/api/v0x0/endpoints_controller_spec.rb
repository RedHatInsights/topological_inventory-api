RSpec.describe Api::V0x0::EndpointsController, type: :controller do
  let(:source) { Source.create! }

  it "delete /endpoints/:id deletes an Endpoint" do
    endpoint = Endpoint.create!(:source => source)

    delete_path(api_v0x0_endpoint_url(endpoint.id))

    expect { endpoint.reload }.to raise_error(ActiveRecord::RecordNotFound)

    expect(response.status).to eq(204)
    expect(response.parsed_body).to be_empty
  end

  it "get /endpoints lists all Endpoints" do
    endpoint = Endpoint.create!(:source => source)

    get_path(api_v0x0_endpoints_url)

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match([a_hash_including("id" => endpoint.id.to_s)])
  end

  it "get /endpoints/:id lists all Endpoints" do
    endpoint = Endpoint.create!(:source => source)

    get_path(api_v0x0_endpoint_url(endpoint.id))

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match(a_hash_including("id" => endpoint.id.to_s))
  end

  it "patch /endpoints/:id updates an Endpoint" do
    endpoint = Endpoint.create!(:source => source, :host => "example.com")

    patch_path(api_v0x0_endpoint_url(endpoint.id), :params => {:host => "example.org"})

    expect(endpoint.reload.host).to eq("example.org")

    expect(response.status).to eq(204)
    expect(response.parsed_body).to be_empty
  end

  it "post /endpoints creates an Endpoint" do
    post_path(api_v0x0_endpoints_url, :body => {:host => "example.com", :source_id => source.id.to_s}.to_json, :format => :json)

    endpoint = Endpoint.first

    expect(response.status).to eq(201)
    expect(response.location).to match(a_string_ending_with("api/v0.0/endpoints/#{endpoint.id}"))
    expect(JSON.parse(response.parsed_body)).to include("host" => "example.com", "id" => endpoint.id.to_s)
  end
end
