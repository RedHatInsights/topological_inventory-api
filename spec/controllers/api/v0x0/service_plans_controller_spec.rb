RSpec.describe Api::V0x0::ServicePlansController, :type => :request do
  it("Uses IndexMixin") { expect(described_class.instance_method(:index).owner).to eq(Api::Mixins::IndexMixin) }
  it("Uses ShowMixin")  { expect(described_class.instance_method(:show).owner).to eq(Api::Mixins::ShowMixin) }

  describe "#order" do
    let(:service_plan) do
      ServicePlan.create!(
        :source           => source,
        :tenant           => tenant,
        :service_offering => service_offering,
        :source_region    => source_region,
        :subscription     => subscription
      )
    end
    let(:source_type) { SourceType.create! }
    let(:source_region) { SourceRegion.create!(:tenant => tenant, :source => source) }
    let(:source) { Source.create!(:tenant => tenant, :source_type => source_type) }
    let(:tenant) { Tenant.create! }
    let(:subscription) { Subscription.create!(:tenant => tenant, :source => source) }
    let(:service_offering) do
      ServiceOffering.create!(:source => source, :tenant => tenant, :source_region => source_region, :subscription => subscription)
    end

    let(:catalog_parameters) { service_parameters.merge(provider_control_parameters) }
    let(:service_parameters) { {"DB_NAME" => "TEST_DB", "namespace" => "TEST_DB_NAMESPACE"} }
    let(:provider_control_parameters) { {"namespace" => "test_project", "OpenShift_param1" => "test"} }

    before do
      allow_any_instance_of(ServicePlan).to receive(:order).with(catalog_parameters).and_return("task_id")
      Rails.application.config.action_dispatch.show_exceptions = false
    end

    after do
      Rails.application.config.action_dispatch.show_exceptions = true
    end

    it "returns json with the task id" do
      payload = {
        "service_parameters"          => service_parameters,
        "provider_control_parameters" => provider_control_parameters
      }

      post "/api/v0.0/service_plans/#{service_plan.id}/order", :params => payload

      body = JSON.parse(response.body)
      expect(body["task_id"]).to eq("task_id")
    end
  end
end
