RSpec.describe Api::V0x0::ServiceInstancesController, :type => :request do
  it("Uses IndexMixin") { expect(described_class.instance_method(:index).owner).to eq(Api::Mixins::IndexMixin) }

  let(:source) { Source.create!(:tenant => tenant) }
  let(:tenant) { Tenant.create! }
  let(:offering) { ServiceOffering.create!(:source => source, :tenant => tenant) }
  let(:params) { ServiceParametersSet.create!(:source => source, :tenant => tenant, :service_offering => offering) }
  let!(:service_instance) { ServiceInstance.create!(:source => source, :tenant => tenant, :service_offering => offering, :service_parameters_set => params) }

  it "get /service_instances/:id lists all ServiceInstances" do
    get(api_v0x0_service_instance_url(service_instance.id))

    expect(response.status).to eq(200)
    expect(response.parsed_body).to match(a_hash_including("id" => service_instance.id.to_s))
  end
end
