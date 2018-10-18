RSpec.describe Api::V0x0::ServiceOfferingsController, :type => :request do
  let(:source) { Source.create!(:tenant => tenant) }
  let(:tenant) { Tenant.create! }

  it "get /service_offerings lists all ServiceOfferings" do
    service_offering = ServiceOffering.create!(:source => source, :tenant => tenant)

    get(api_v0x0_service_offerings_url)

    expect(response.status).to eq(200)
    expect(response.parsed_body).to match([a_hash_including("id" => service_offering.id.to_s)])
  end

  it "get /service_offerings/:id lists all ServiceOfferings" do
    service_offering = ServiceOffering.create!(:source => source, :tenant => tenant)

    get(api_v0x0_service_offering_url(service_offering.id))

    expect(response.status).to eq(200)
    expect(response.parsed_body).to match(a_hash_including("id" => service_offering.id.to_s))
  end
end
