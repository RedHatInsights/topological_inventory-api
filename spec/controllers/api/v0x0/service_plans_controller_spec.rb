RSpec.describe Api::V0x0::ServicePlansController, :type => :request do
  it("Uses IndexMixin") { expect(described_class.instance_method(:index).owner).to eq(Api::Mixins::IndexMixin) }
  it("Uses ShowMixin")  { expect(described_class.instance_method(:show).owner).to eq(Api::Mixins::ShowMixin) }

  describe "#order" do
    let(:service_plan) { instance_double("ServicePlan", :id => 123) }

    before do
      allow(ServicePlan).to receive(:find).with(123).and_return(service_plan)
      allow(service_plan).to receive(:order).with(321, "other params").and_return("task_id")
    end

    it "returns json with the task id" do
      payload = {:id => 123, :catalog_id => 321, :other_params? => "other params"}.to_json
      post "order", :params => payload, :format => "json"
      body = JSON.parse(response.body)
      expect(body[:task_id]).to eq("task_id")
    end
  end
end
