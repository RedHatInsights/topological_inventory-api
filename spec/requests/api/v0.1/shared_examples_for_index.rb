RSpec.shared_examples "test_index_and_subcollections" do |primary_collection, subcollections|
  let(:collection_path) { "/api/v0.1/#{primary_collection}" }

  describe("/api/v0.1/#{primary_collection}") do
    context "get" do
      it "success: empty collection" do
        get(collection_path)

        expect(response).to have_attributes(
                              :status      => 200,
                              :parsed_body => paginated_response(0, [])
                            )
      end

      it "success: non-empty collection" do
        primary_collection.to_s.singularize.camelize.constantize.create!(attributes)

        get(collection_path)

        expect(response).to have_attributes(
                              :status      => 200,
                              :parsed_body => paginated_response(1, [a_hash_including(attributes.except("tenant_id"))])
                            )
      end
    end
  end

  describe("/api/v0.1/#{primary_collection}/:id") do
    def instance_path(id)
      File.join(collection_path, id.to_s)
    end

    context "get" do
      it "success: with a valid id" do
        instance = primary_collection.to_s.singularize.camelize.constantize.create!(attributes)

        get(instance_path(instance.id))

        expect(response).to have_attributes(
                              :status      => 200,
                              :parsed_body => a_hash_including(attributes.merge("id" => instance.id.to_s).except("tenant_id"))
                            )
      end

      it "failure: with an invalid id" do
        instance = primary_collection.to_s.singularize.camelize.constantize.create!(attributes)

        get(instance_path(instance.id * 1000))

        expect(response).to have_attributes(
                              :status      => 404,
                              :parsed_body => ""
                            )
      end
    end
  end

  describe("subcollections") do
    subcollections.each do |subcollection|
      describe("/api/v0.1/#{primary_collection}/:id/#{subcollection}") do
        let(:subcollection) { subcollection }

        def subcollection_path(id)
          File.join(collection_path, id.to_s, subcollection)
        end

        context "get" do
          it "success: with a valid id" do
            instance = primary_collection.to_s.singularize.camelize.constantize.create!(attributes)

            get(subcollection_path(instance.id))

            expect(response).to have_attributes(
                                  :status      => 200,
                                  :parsed_body => paginated_response(0, [])
                                )
          end

          it "failure: with an invalid id" do
            instance   = primary_collection.to_s.singularize.camelize.constantize.create!(attributes)
            missing_id = (instance.id * 1000)
            expect(primary_collection.to_s.singularize.camelize.constantize.exists?(missing_id)).to eq(false)

            get(subcollection_path(missing_id))

            expect(response).to have_attributes(
                                  :status      => 404,
                                  :parsed_body => {"errors" => [{"detail" => "Couldn't find #{primary_collection.to_s.singularize.camelize} with 'id'=#{missing_id}", "status" => 404}]}
                                )
          end
        end
      end
    end
  end
end
