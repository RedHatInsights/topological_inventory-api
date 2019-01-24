class ApplicationController < ActionController::API

  private

  def body_params
    ActionController::Parameters.new(JSON.parse(request.body.read))
  end

  def instance_link(instance)
    endpoint = instance.class.name.downcase
    version  = self.class.name.split("::")[1].downcase
    send("api_#{version}_#{endpoint}_url", instance.id)
  end
end
