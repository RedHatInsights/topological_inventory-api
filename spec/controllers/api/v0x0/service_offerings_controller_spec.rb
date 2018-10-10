RSpec.describe Api::V0x0::ServiceOfferingsController, type: :controller do
  let(:source) { Source.create! }
  it "get /service_offerings lists all ServiceOfferings" do
    service_offering = ServiceOffering.create!(:source => source)

    get_path(api_v0x0_service_offerings_url)

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match([a_hash_including("id" => service_offering.id.to_s)])
  end

  it "get /service_offerings/:id lists all ServiceOfferings" do
    service_offering = ServiceOffering.create!(:source => source)

    get_path(api_v0x0_service_offering_url(service_offering.id))

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match(a_hash_including("id" => service_offering.id.to_s))
  end

  def get_path(path)
    parsed_params = Rails.application.routes.recognize_path(path)
    get(parsed_params[:action], :params => parsed_params.except(:action, :controller))
  end
end
