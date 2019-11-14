require_relative "shared_examples_for_index"

RSpec.describe("v2.0 - ContainerNode") do
  include ::Spec::Support::TenantIdentity

  let(:headers) { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
  let(:source) { Source.create!(:tenant => tenant) }

  let(:attributes) do
    {
      "source_id"            => source.id.to_s,
      "tenant_id"            => tenant.id.to_s,
      "source_ref"           => SecureRandom.uuid
    }
  end

  include_examples(
    "v2x0_test_index_and_subcollections",
    "container_nodes",
    ["tags", "container_groups"],
  )

  describe("/api/v2.0/container_nodes/:id/tags") do
    let(:instance) { ContainerNode.create!(attributes) }
    let(:tags_subcollection) { "/api/v2.0/container_nodes/#{instance.id}/tags" }

    context "get" do
      it "success: no tags" do
        get(tags_subcollection, :headers => headers)

        expect(response).to have_attributes(
          :status      => 200,
          :parsed_body => a_hash_including("data" => [])
        )
      end

      it "success: with tags" do
        instance.tags << Tag.create!(:tag => "/a/b/c=d", :tenant_id => tenant.id)
        instance.tags << Tag.create!(:tag => "/x/y=z", :tenant_id => tenant.id)

        get(tags_subcollection, :headers => headers)

        expect(response).to have_attributes(
          :status      => 200,
          :parsed_body => paginated_response(2, [{"tag" => "/a/b/c=d"}, {"tag" => "/x/y=z"}])
        )
      end
    end

    context "post" do
      it "works" do
        payload = {"tag" => "/a/b/c=d"}
        post(tags_subcollection, :params => payload.to_json, :headers => headers)

        expect(response).to have_attributes(
          :status => 201,
          :location => "http://www.example.com/api/v2.0/container_nodes/#{instance.id}/tags",
          :parsed_body => payload
        )
      end
    end
  end
end
