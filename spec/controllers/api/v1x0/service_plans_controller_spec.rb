require "manageiq-messaging"
require "sources-api-client"

RSpec.describe Api::V1x0::ServicePlansController, :type => :request do
  include ::Spec::Support::TenantIdentity
  let(:headers) { {"x-rh-identity" => identity} }

  it("Uses IndexMixin") { expect(described_class.instance_method(:index).owner).to eq(Api::V1::Mixins::IndexMixin) }
  it("Uses ShowMixin")  { expect(described_class.instance_method(:show).owner).to eq(Api::V1::Mixins::ShowMixin) }

  describe "#order" do
    let(:service_plan) do
      ServicePlan.create!(
        :source           => source,
        :tenant           => tenant,
        :service_offering => service_offering,
        :source_region    => source_region,
        :subscription     => subscription,
        :source_ref       => SecureRandom.uuid
      )
    end
    let(:source_region) { SourceRegion.create!(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid) }
    let(:source) { Source.create!(:tenant => tenant, :uid => SecureRandom.uuid) }
    let(:subscription) { Subscription.create!(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid) }
    let(:service_inventory) { ServiceInventory.create!(:tenant => tenant, :source => source, :source_ref => "something?") }
    let(:service_offering) do
      ServiceOffering.create!(
        :service_inventory => service_inventory,
        :source            => source,
        :source_ref        => SecureRandom.uuid,
        :source_region     => source_region,
        :subscription      => subscription,
        :tenant            => tenant,
      )
    end

    let(:service_parameters) { {"DB_NAME" => "TEST_DB", "namespace" => "TEST_DB_NAMESPACE", "nested" => {"deep" => "things"}} }
    let(:provider_control_parameters) { {"namespace" => "test_project", "OpenShift_param1" => "test", "nested" => {"deep" => "things"}} }

    context "with a well formed service plan id" do
      let(:client) { double(:client) }
      let(:payload) do
        {
          "service_parameters"          => service_parameters,
          "provider_control_parameters" => provider_control_parameters
        }
      end

      before do
        allow(ManageIQ::Messaging::Client).to receive(:open).and_return(client)
        allow(client).to receive(:publish_topic)

        source_type = double
        allow(source_type).to receive(:name).and_return("openshift")
        allow_any_instance_of(described_class).to receive(:retrieve_source_type).and_return(source_type)
      end

      it "publishes a message to the messaging client" do
        expect(client).to receive(:publish_topic).with(
          :service => "platform.topological-inventory.operations-openshift",
          :event   => "ServicePlan.order",
          :payload => {:request_context => headers, :params => {:task_id => kind_of(String), :service_plan_id => service_plan.id.to_s, :order_params => payload}}
        )

        post "/api/v1.0/service_plans/#{service_plan.id}/order", :params => payload.to_json, :headers => headers
      end

      it "returns json with the task id" do
        post "/api/v1.0/service_plans/#{service_plan.id}/order", :params => payload.to_json, :headers => headers

        @body = JSON.parse(response.body)
        expect(@body).to have_key("task_id")
      end
    end

    context "with an error in sources api" do
      let(:client) { double(:client) }
      let(:payload) do
        {
          "service_parameters"          => service_parameters,
          "provider_control_parameters" => provider_control_parameters
        }
      end
      let(:error_message) { "Sample error message" }

      before do
        allow(ManageIQ::Messaging::Client).to receive(:open).and_return(client)
        allow(client).to receive(:publish_topic)

        allow_any_instance_of(described_class).to receive(:retrieve_source_type).and_raise(SourcesApiClient::ApiError.new(error_message))
      end

      it "returns an error" do
        post "/api/v1.0/service_plans/#{service_plan.id}/order", :params => payload.to_json, :headers => headers

        @body = JSON.parse(response.body)
        expect(@body).to have_key("errors")
        expect(@body['errors'][0]['detail']).to eq("Error message: the server returns an error")
      end
    end

    context "with a malicious service plan id" do
      it "returns an error" do
        post "/api/v1.0/service_plans/;myfakeSQLinjection/order", :headers => headers

        expect(response.status).to eq(400)
      end

      it "does not try to look the model up by the fake ID" do
        expect(ServicePlan).to_not receive(:find).with(";myfakeSQLinjection")

        post "/api/v1.0/service_plans/;myfakeSQLinjection/order", :headers => headers
      end
    end
  end
end
