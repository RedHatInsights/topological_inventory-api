require "manageiq-messaging"

RSpec.describe Api::V0x1::TasksController, :type => :request do
  it("Uses IndexMixin")   { expect(described_class.instance_method(:index).owner).to eq(Api::V0x1::Mixins::IndexMixin) }
  it("Uses ShowMixin")    { expect(described_class.instance_method(:show).owner).to eq(Api::V0::Mixins::ShowMixin) }

  let(:tenant) { Tenant.find_or_create_by!(:name => "default", :external_tenant => "external_tenant_uuid")}
  let(:client) { instance_double("ManageIQ::Messaging::Client") }

  before do
    allow(ManageIQ::Messaging::Client).to receive(:open).and_return(client)
    allow(client).to receive(:publish_message)
  end

  it "patch /tasks/:id updates a Task" do
    task = Task.create!(:state => "running", :status => "ok", :context => "context1", :tenant => tenant)
    expect(client).to receive(:publish_message).with(
      :service => "platform.topological-inventory.task-output-stream",
      :message => "Task.update",
      :payload => {"state" => "completed", "status" => "ok", "context" => "context2", "task_id" => task.id.to_s}
    )

    patch(api_v0x1_task_url(task.id), :params => {:state => "completed", :status => "ok", :context => "context2"}.to_json)

    expect(task.reload.state).to eq("completed")
    expect(task.reload.status).to eq("ok")
    expect(task.context).to eq("context2")

    expect(response.status).to eq(204)
    expect(response.parsed_body).to be_empty
  end
end
