RSpec.describe Api::V0x0::AuthenticationsController, type: :controller do
  let(:endpoint) { Endpoint.create!(:source => source) }
  let(:source)   { Source.create! }

  it "delete /authentications/:id deletes an Authentication" do
    authentication = Authentication.create!(:resource => endpoint)

    delete_path(api_v0x0_authentication_url(authentication.id))

    expect { authentication.reload }.to raise_error(ActiveRecord::RecordNotFound)

    expect(response.status).to eq(204)
    expect(response.parsed_body).to be_empty
  end

  it "get /authentications lists all Authentications" do
    authentication = Authentication.create!(:resource => endpoint)

    get_path(api_v0x0_authentications_url)

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match([a_hash_including("id" => authentication.id.to_s)])
  end

  it "get /authentications/:id lists all Authentications" do
    authentication = Authentication.create!(:resource => endpoint)

    get_path(api_v0x0_authentication_url(authentication.id))

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match(a_hash_including("id" => authentication.id.to_s))
  end

  it "patch /authentications/:id updates an Authentication" do
    authentication = Authentication.create!(:name => "original_name", :resource => endpoint)

    patch_path(api_v0x0_authentication_url(authentication.id), :params => {:name => "new_name"})

    expect(authentication.reload.name).to eq("new_name")

    expect(response.status).to eq(204)
    expect(response.parsed_body).to be_empty
  end

  it "post /authentications creates an Authentication" do
    post_path(api_v0x0_authentications_url, :body => {:name => "original_name", :resource_id => endpoint.id.to_s, :resource_type => endpoint.class.name}.to_json, :format => :json)

    authentication = Authentication.first

    expect(response.status).to eq(201)
    expect(response.location).to match(a_string_ending_with("api/v0.0/authentications/#{authentication.id}"))
    expect(JSON.parse(response.parsed_body)).to include("name" => "original_name", "id" => authentication.id.to_s)
  end
end
