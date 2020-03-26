RSpec.shared_examples "v3x0_test_tags_subcollection" do |primary_collection|
  let(:collection_path) { "/api/v3.0/#{primary_collection}" }
  let(:instance)        { primary_collection.singularize.camelize.constantize.create!(attributes) }

  describe("tags_subcollections") do
    describe("/api/v3.0/#{primary_collection}/:id/tags") do
      let(:tags_subcollection) { "/api/v3.0/#{primary_collection}/#{instance.id}/tags" }

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

      context "tag" do
        let(:instance_tag_url) { "/api/v3.0/#{primary_collection}/#{instance.id}/tag" }

        it "not yet tagged" do
          payload = [{"tag" => "/a/b/c=d"}]
          post(instance_tag_url, :params => payload.to_json, :headers => headers)

          expect(response).to have_attributes(
            :status => 201,
            :location => "http://www.example.com/api/v3.0/#{primary_collection}/#{instance.id}/tags",
            :parsed_body => payload
          )
        end

        it "already tagged" do
          instance.tags << Tag.create!(:namespace => "a", :name => "b/c", :value => "d", :tenant => tenant)

          payload = [{"tag" => "/a/b/c=d"}]
          post(instance_tag_url, :params => payload.to_json, :headers => headers)

          expect(response).to have_attributes(
            :status => 304,
            :location => "http://www.example.com/api/v3.0/#{primary_collection}/#{instance.id}/tags",
            :parsed_body => ""
          )
        end

        it "already tagged and new tag" do
          instance.tags << Tag.create!(:namespace => "a", :name => "b/c", :value => "d", :tenant => tenant)

          payload = [{"tag" => "/a/b/c=d"}, {"tag" => "/x/y/z=1"}]
          post(instance_tag_url, :params => payload.to_json, :headers => headers)

          expect(response).to have_attributes(
            :status => 201,
            :location => "http://www.example.com/api/v3.0/#{primary_collection}/#{instance.id}/tags",
            :parsed_body => [{"tag" => "/a/b/c=d"}, {"tag" => "/x/y/z=1"}]
          )
        end
      end

      context "untag" do
        it "works" do
          payload = [{"tag" => "/a/b/c=d"}]
          tag_1 = Tag.create!(:tag => "/a/b/c=d", :tenant_id => tenant.id)
          tag_2 = Tag.create!(:tag => "/x/y=z",   :tenant_id => tenant.id)
          instance.tags << tag_1
          instance.tags << tag_2

          expect(instance.tags.reload).to match_array([tag_1, tag_2])

          post("/api/v3.0/#{primary_collection}/#{instance.id}/untag", :params => payload.to_json, :headers => headers)

          expect(response).to have_attributes(
            :status => 204,
            :location => "http://www.example.com/api/v3.0/#{primary_collection}/#{instance.id}/tags",
            :parsed_body => ""
          )

          expect(instance.tags.reload).to match_array([tag_2])
          expect(Tag.exists?(tag_1.id)).to eq(true)
        end
      end
    end
  end
end
