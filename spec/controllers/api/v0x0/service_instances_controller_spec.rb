RSpec.describe Api::V0x0::ServiceInstancesController, type: :controller do
  let(:source) { Source.create!(:tenant => tenant) }
  let(:tenant) { Tenant.create! }
  let(:offering) { ServiceOffering.create!(:source => source, :tenant => tenant) }
  let(:params) { ServiceParametersSet.create!(:source => source, :tenant => tenant, :service_offering => offering) }
  let!(:service_instance) { ServiceInstance.create!(:source => source, :tenant => tenant, :service_offering => offering, :service_parameters_set => params) }

  it "get /service_instances lists all ServiceInstances" do
    get_path(api_v0x0_service_instances_url)

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match([a_hash_including("id" => service_instance.id.to_s)])
  end

  it "get /service_instances/:id lists all ServiceInstances" do
    get_path(api_v0x0_service_instance_url(service_instance.id))

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match(a_hash_including("id" => service_instance.id.to_s))
  end
end
