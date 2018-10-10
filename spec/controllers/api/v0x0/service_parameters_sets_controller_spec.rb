RSpec.describe Api::V0x0::ServiceParametersSetsController, type: :controller do
  let(:service_offering) { ServiceOffering.create!(:source => source) }
  let(:source) { Source.create! }

  it "get /service_parameters_sets lists all ServiceParametersSets" do
    service_parameters_set = ServiceParametersSet.create!(:service_offering => service_offering, :source => source)

    get_path(api_v0x0_service_parameters_sets_url)

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match([a_hash_including("id" => service_parameters_set.id.to_s)])
  end

  it "get /service_parameters_sets/:id lists all ServiceParametersSets" do
    service_parameters_set = ServiceParametersSet.create!(:service_offering => service_offering, :source => source)

    get_path(api_v0x0_service_parameters_set_url(service_parameters_set.id))

    expect(response.status).to eq(200)
    expect(JSON.parse(response.parsed_body)).to match(a_hash_including("id" => service_parameters_set.id.to_s))
  end

  def get_path(path)
    parsed_params = Rails.application.routes.recognize_path(path)
    get(parsed_params[:action], :params => parsed_params.except(:action, :controller))
  end
end
