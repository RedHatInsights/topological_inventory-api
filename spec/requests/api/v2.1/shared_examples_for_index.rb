RSpec.shared_examples "v2x1_test_index_and_subcollections" do |primary_collection, subcollections|
  let(:collection_path) { "/api/v2.1/#{primary_collection}" }

  describe("/api/v2.1/#{primary_collection}") do
    context "get" do
      it "success: empty collection" do
        get(collection_path, :headers => headers)

        expect(response).to have_attributes(
                              :status      => 200,
                              :parsed_body => paginated_response(0, [])
                            )
      end

      it "success: non-empty collection" do
        primary_collection.to_s.singularize.camelize.constantize.create!(attributes)

        get(collection_path, :headers => headers)

        expect(response).to have_attributes(
                              :status      => 200,
                              :parsed_body => paginated_response(1, [a_hash_including(attributes.except("tenant_id"))])
                            )
      end
    end
  end

  describe("/api/v2.1/#{primary_collection}/:id") do
    def instance_path(id)
      File.join(collection_path, id.to_s)
    end

    context "get" do
      it "success: with a valid id" do
        instance = primary_collection.to_s.singularize.camelize.constantize.create!(attributes)

        get(instance_path(instance.id), :headers => headers)

        response_attributes = attributes.except("tenant_id")
        response_attributes.merge("id" => instance.id.to_s) unless primary_collection == "tags"

        expect(response).to have_attributes(
                              :status      => 200,
                              :parsed_body => a_hash_including(response_attributes)
                             )
      end

      it "failure: with an invalid id" do
        instance = primary_collection.to_s.singularize.camelize.constantize.create!(attributes)

        missing_id = instance.id * 1000
        get(instance_path(missing_id), :headers => headers)

        expect(response).to have_attributes(
                              :status      => 404,
                              :parsed_body => {"errors" => [{"detail" => "Record not found", "status" => 404}]}
                            )
      end

      it "failure: with an invalid non-numeric id" do
        get(instance_path("non_numeric_id"), :headers => headers)

        expect(response).to have_attributes(
                              :status      => 400,
                              :parsed_body => {"errors" => [{"detail" => "Insights::API::Common::ApplicationControllerMixins::RequestPath::RequestPathError: ID is invalid", "status" => 400}]}
                            )
      end
    end
  end

  describe("subcollections") do
    subcollections.each do |subcollection|
      describe("/api/v2.1/#{primary_collection}/:id/#{subcollection.to_s}") do
        let(:subcollection) { subcollection.to_s }

        def subcollection_path(id)
          File.join(collection_path, id.to_s, subcollection)
        end

        context "get" do
          it "success: with a valid id" do
            instance = primary_collection.to_s.singularize.camelize.constantize.create!(attributes)

            get(subcollection_path(instance.id), :headers => headers)

            expect(response).to have_attributes(
                                  :status      => 200,
                                  :parsed_body => paginated_response(0, [])
                                )
          end

          it "failure: with an invalid id" do
            instance   = primary_collection.to_s.singularize.camelize.constantize.create!(attributes)
            missing_id = (instance.id * 1000)
            expect(primary_collection.to_s.singularize.camelize.constantize.exists?(missing_id)).to eq(false)

            get(subcollection_path(missing_id), :headers => headers)

            expect(response).to have_attributes(
                                  :status      => 404,
                                  :parsed_body => {"errors" => [{"detail" => "Record not found", "status" => 404}]}
                                )
          end

          it "failure: with an invalid non-numeric id" do
            get(subcollection_path("non_numeric_id"), :headers => headers)

            expect(response).to have_attributes(
                                  :status      => 400,
                                  :parsed_body => {"errors" => [{"detail" => "Insights::API::Common::ApplicationControllerMixins::RequestPath::RequestPathError: ID is invalid", "status" => 400}]}
                                )
          end
        end
      end
    end
  end
end
