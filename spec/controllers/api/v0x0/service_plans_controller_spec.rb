RSpec.describe Api::V0x0::ServicePlansController, :type => :request do
  it("Uses IndexMixin") { expect(described_class.instance_method(:index).owner).to eq(Api::Mixins::IndexMixin) }
  it("Uses ShowMixin")  { expect(described_class.instance_method(:show).owner).to eq(Api::Mixins::ShowMixin) }

  describe "#order" do
    let(:service_plan) { ServicePlan.new(:id => 123) }

    let(:catalog_parameters) { service_parameters.merge(provider_control_parameters) }
    let(:service_parameters) { {"DB_NAME" => "TEST_DB", "namespace" => "TEST_DB_NAMESPACE"} }
    let(:provider_control_parameters) { {"namespace" => "test_project", "OpenShift_param1" => "test"} }

    before do
      allow(ServicePlan).to receive(:find).with("123").and_return(service_plan)
      allow(service_plan).to receive(:order).with("321", catalog_parameters).and_return("task_id")
      Rails.application.config.action_dispatch.show_exceptions = false
    end

    after do
      Rails.application.config.action_dispatch.show_exceptions = true
    end

    it "returns json with the task id" do
      payload = {
        :catalog_id                   => 321,
        "service_parameters"          => service_parameters,
        "provider_control_parameters" => provider_control_parameters
      }

      post "/api/v0.0/service_plans/123/order", :params => payload

      body = JSON.parse(response.body)
      expect(body["task_id"]).to eq("task_id")
    end
  end
end
