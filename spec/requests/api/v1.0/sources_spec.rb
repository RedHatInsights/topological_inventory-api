require_relative "shared_examples_for_index"

RSpec.describe("v0.0 - Sources") do
  include ::Spec::Support::TenantIdentity

  let(:headers)         { {"CONTENT_TYPE" => "application/json", "x-rh-identity" => identity} }
  let(:attributes)      { {"tenant_id" => tenant.id.to_s} }
  let(:collection_path) { "/api/v1.0/sources" }

  include_examples(
    "v1x0_test_index_and_subcollections",
    "sources",
    [
      "applications",
      "container_groups",
      "container_images",
      "container_nodes",
      "container_projects",
      "container_templates",
      "containers",
      "endpoints",
      "orchestration_stacks",
      "service_instances",
      "service_offerings",
      "service_plans",
      "vms",
      "volume_types",
      "volumes",
    ],
  )

  describe("/api/v1.0/sources/:id") do
    def instance_path(id)
      File.join(collection_path, id.to_s)
    end
  end

  describe("subcollections") do
    existing_subcollections = [
      "container_groups",
      "container_images",
      "container_nodes",
      "container_projects",
      "container_templates",
      "containers",
      "orchestration_stacks",
      "service_instances",
      "service_offerings",
      "service_plans",
      "vms",
      "volume_types",
      "volumes",
    ]

    existing_subcollections.each do |subcollection|
      describe("/api/v0.0/sources/:id/#{subcollection}") do
        let(:subcollection) { subcollection }

        def subcollection_path(id)
          File.join(collection_path, id.to_s, subcollection)
        end

        context "get" do
          it "success: with a valid id" do
            instance = Source.create!(attributes)

            get(subcollection_path(instance.id), :headers => headers)

            expect(response).to have_attributes(
              :status => 200,
              :parsed_body => []
            )
          end

          it "failure: with an invalid id" do
            instance = Source.create!(attributes)
            missing_id = (instance.id * 1000)
            expect(Source.exists?(missing_id)).to eq(false)

            get(subcollection_path(missing_id), :headers => headers)

            expect(response).to have_attributes(
              :status => 404,
              :parsed_body => {"errors"=>[{"detail"=>"Record not found", "status"=>404}]}
            )
          end
        end
      end
    end
  end
end
