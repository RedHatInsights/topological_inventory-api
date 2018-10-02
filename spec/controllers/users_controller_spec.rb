RSpec.describe UsersController do
  it "get /sources works" do
    source = Source.create!(:name => "test_source")

    get :list_sources

    expect(JSON.parse(response.parsed_body)).to match([a_hash_including("id" => source.id.to_s)])
  end
end