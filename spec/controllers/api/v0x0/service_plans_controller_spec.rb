RSpec.describe Api::V0x0::ServicePlansController, :type => :request do
  include ::Spec::Support::TenantIdentity

  it("Uses IndexMixin") { expect(described_class.instance_method(:index).owner).to eq(Api::V0::Mixins::IndexMixin) }
  it("Uses ShowMixin")  { expect(described_class.instance_method(:show).owner).to eq(Api::V0::Mixins::ShowMixin) }

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
    let(:source_type) do
      SourceType.create!(:name => "source_type", :product_name => "product_name", :vendor => "vendor")
    end
    let(:source_region) { SourceRegion.create!(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid) }
    let(:source) { Source.create!(:tenant => tenant, :source_type => source_type, :uid => SecureRandom.uuid, :name => "test_source") }
    let(:subscription) { Subscription.create!(:tenant => tenant, :source => source, :source_ref => SecureRandom.uuid) }
    let(:service_offering) do
      ServiceOffering.create!(
        :source        => source,
        :tenant        => tenant,
        :source_region => source_region,
        :subscription  => subscription,
        :source_ref    => SecureRandom.uuid
      )
    end

    let(:order_parameters) do
      {
        :service_parameters          => service_parameters,
        :provider_control_parameters => provider_control_parameters
      }
    end
    let(:service_parameters) { {"DB_NAME" => "TEST_DB", "namespace" => "TEST_DB_NAMESPACE"} }
    let(:provider_control_parameters) { {"namespace" => "test_project", "OpenShift_param1" => "test"} }

    before do
      allow_any_instance_of(ServicePlan).to receive(:order).with(order_parameters).and_return("task_context")
    end

    context "with a well formed service plan id" do
      before do
        payload = {
          "service_parameters"          => service_parameters,
          "provider_control_parameters" => provider_control_parameters
        }

        post "/api/v0.0/service_plans/#{service_plan.id}/order", :params => payload, :headers => {"x-rh-identity" => identity}

        @body = JSON.parse(response.body)
      end

      it "returns json with the task id" do
        expect(@body).to have_key("task_id")
      end

      it "sets the context based on the results of the order and sets the status of the task to completed" do
        expect(Task.find(@body["task_id"])).to have_attributes(:context => "task_context", :status => "completed")
      end
    end

    context "with a malicious service plan id" do
      it "returns an error" do
        post "/api/v0.0/service_plans/;myfakeSQLinjection/order", :headers => {"x-rh-identity" => identity}

        expect(response.status).to eq(400)
      end

      it "does not try to look the model up by the fake ID" do
        expect(ServicePlan).to_not receive(:find).with(";myfakeSQLinjection")

        post "/api/v0.0/service_plans/;myfakeSQLinjection/order"
      end
    end
  end
end
