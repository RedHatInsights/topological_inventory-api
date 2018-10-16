describe "Swagger stuff" do
  let(:rails_routes) do
    Rails.application.routes.routes.each_with_object([]) do |route, array|
      r = ActionDispatch::Routing::RouteWrapper.new(route)
      next if r.internal? # Don't display rails routes
      next if r.engine? # Don't care right now...

      array << {:verb => r.verb, :path => r.path.split("(").first}
    end
  end

  let(:swagger_docs) { Spec::Support::SwaggerDocs.new }
  let(:swagger_routes) { swagger_docs.routes }

  it "routes match" do
    expect(rails_routes).to match_array(swagger_routes)
  end
end
