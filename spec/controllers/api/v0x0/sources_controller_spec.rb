RSpec.describe Api::V0x0::SourcesController, :type => :request do
  it("Uses IndexMixin") { expect(described_class.instance_method(:index).owner).to eq(Api::Mixins::IndexMixin) }

  let(:tenant) { Tenant.create! }

  it "delete /sources/:id deletes a Source" do
    source = Source.create!(:tenant => tenant, :name => "test_source")

    delete(api_v0x0_source_url(source.id))

    expect { source.reload }.to raise_error(ActiveRecord::RecordNotFound)

    expect(response.status).to eq(204)
    expect(response.parsed_body).to be_empty
  end

  it "get /sources/:id lists all Sources" do
    source = Source.create!(:tenant => tenant, :name => "test_source")

    get(api_v0x0_source_url(source.id))

    expect(response.status).to eq(200)
    expect(response.parsed_body).to match(a_hash_including("id" => source.id.to_s))
  end

  it "patch /sources/:id updates a Source" do
    source = Source.create!(:tenant => tenant, :name => "abc")

    patch(api_v0x0_source_url(source.id), :params => {:name => "xyz"})

    expect(source.reload.name).to eq("xyz")

    expect(response.status).to eq(204)
    expect(response.parsed_body).to be_empty
  end

  it "post /sources creates a Source" do
    headers = { "CONTENT_TYPE" => "application/json" }
    post(api_v0x0_sources_url, :params => {:tenant_id => tenant.id.to_s, :name => "abc"}.to_json)

    source = Source.first

    expect(response.status).to eq(201)
    expect(response.location).to match(a_string_ending_with("api/v0.0/sources/#{source.id}"))
    expect(response.parsed_body).to include("name" => "abc", "id" => source.id.to_s)
  end
end
