require_relative "shared_examples_for_index"

RSpec.describe("v0.1 - ServiceOfferingIcon") do
  let(:source) { Source.create!(:name => "name", :source_type => source_type, :tenant => tenant) }
  let(:source_type) { SourceType.create!(:vendor => "vendor", :product_name => "product_name", :name => "name") }
  let(:tenant) { Tenant.create! }
  let(:data) { '<svg width=\"580\" height=\"400\" xmlns=\"http://www.w3.org/2000/svg\"> <!-- Created with Method Draw -'\
    'http://github.com/duopixel/Method-Draw/ --> <g>  <title>background</title>  <rect fill=\"#ff0000\" '\
    'id=\"canvas_background\" height=\"402\" width=\"582\" y=\"-1\" x=\"-1\"/>  <g display=\"none\" overflow=\"visible\"'\
    ' y=\"0\" x=\"0\" height=\"100%\" width=\"100%\" id=\"canvasGrid\">   <rect fill=\"url(#gridpattern)\" '\
    'stroke-width=\"0\" y=\"0\" x=\"0\" height=\"100%\" width=\"100%\"/>  </g> </g> <g>  <title>Layer 1</title> </g></svg>' }

  let(:attributes) do
    {
      "source_id"            => source.id.to_s,
      "tenant_id"            => tenant.id.to_s,
      "source_ref"           => SecureRandom.uuid,
      "data"                 => data
    }
  end

  include_examples(
    "test_index_and_subcollections",
    "service_offering_icons",
    [],
  )

  describe("/api/v0.1/service_offering_icons/:id/icon_data") do
    let(:primary_collection) { "service_offering_icons" }
    let(:subcollection) { "icon_data" }
    let(:collection_path) { "/api/v0.1/#{primary_collection}" }

    def subcollection_path(id)
      File.join(collection_path, id.to_s, subcollection)
    end

    context "get" do
      it "success: with a valid id" do
        instance = primary_collection.to_s.singularize.camelize.constantize.create!(attributes)

        get(subcollection_path(instance.id))

        expect(response).to have_attributes(
                              :status       => 200,
                              :parsed_body  => data,
                              :content_type => "image/svg+xml"
                              )
      end

      it "failure: with an invalid id" do
        instance   = primary_collection.to_s.singularize.camelize.constantize.create!(attributes)
        missing_id = (instance.id * 1000)
        expect(primary_collection.to_s.singularize.camelize.constantize.exists?(missing_id)).to eq(false)

        get(subcollection_path(missing_id))

        expect(response).to have_attributes(
                              :status      => 404,
                              :parsed_body => ""
                            )
      end

      it "failure: with an invalid non-numeric id" do
        get(subcollection_path("non_numeric_id"))

        expect(response).to have_attributes(
                              :status      => 404,
                              :parsed_body => ""
                            )
      end
    end
  end
end
