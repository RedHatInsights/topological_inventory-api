describe "Swagger stuff" do
  let(:rails_routes) do
    Rails.application.routes.routes.each_with_object([]) do |route, array|
      r = ActionDispatch::Routing::RouteWrapper.new(route)
      next if r.internal? # Don't display rails routes
      next if r.engine? # Don't care right now...

      array << {:verb => r.verb, :path => r.path.split("(").first.sub(/:[_a-z]*id/, ":id")}
    end
  end

  let(:swagger_docs) { Spec::Support::SwaggerDocs.new }
  let(:swagger_routes) { swagger_docs.routes }

  it "routes match" do
    expect(rails_routes).to match_array(swagger_routes)
  end

  describe "Model serialization" do
    let(:doc) { Api::Docs[version] }
    let(:container_group) { ContainerGroup.create!(doc.example_attributes("ContainerGroup").symbolize_keys.merge(:tenant => tenant, :source => source, :container_node => container_node, :container_project => container_project, :source_created_at => Time.now, :source_ref => SecureRandom.uuid)) }
    let(:container_node) { ContainerNode.create!(doc.example_attributes("ContainerNode").symbolize_keys.merge(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid, :source_created_at => Time.now)) }
    let(:container_project) { ContainerProject.create!(doc.example_attributes("ContainerProject").symbolize_keys.merge(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid)) }
    let(:container_template) { ContainerTemplate.create!(doc.example_attributes("ContainerTemplate").symbolize_keys.merge(:tenant => tenant, :source => source, :container_project => container_project, :source_created_at => Time.now, :source_ref => SecureRandom.uuid)) }
    let(:endpoint) { Endpoint.create!(doc.example_attributes("Endpoint").symbolize_keys.merge(:tenant => tenant, :source => source)) }
    let(:service_instance) { ServiceInstance.create!(doc.example_attributes("ServiceInstance").symbolize_keys.merge(:tenant => tenant, :source => source, :service_offering => service_offering, :service_plan => service_plan, :source_created_at => Time.now, :source_ref => SecureRandom.uuid)) }
    let(:service_offering) { ServiceOffering.create!(doc.example_attributes("ServiceOffering").symbolize_keys.merge(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid, :source_created_at => Time.now)) }
    let(:service_plan) { ServicePlan.create!(doc.example_attributes("ServicePlan").symbolize_keys.merge(:tenant => tenant, :source => source, :service_offering => service_offering, :source_ref => SecureRandom.uuid, :source_created_at => Time.now, :create_json_schema => {}, :update_json_schema => {})) }
    let(:source) { Source.create!(doc.example_attributes("Source").symbolize_keys.merge(:tenant => tenant, :uid => SecureRandom.uuid)) }
    let(:tenant) { Tenant.create! }

    context "v0.0" do
      let(:version) { "0.0" }
      Api::Docs["0.0"].definitions.each do |definition_name, schema|
        next if definition_name.in?(["Id"])

        it "#{definition_name} matches the JSONSchema" do
          const = definition_name.constantize
          expect(send(definition_name.underscore).as_json(:prefixes => ["api/v0x0/#{definition_name.underscore}"])).to match_json_schema("0.0", definition_name)
        end
      end
    end
  end
end
