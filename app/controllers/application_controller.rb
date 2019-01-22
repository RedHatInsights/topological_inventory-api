class ApplicationController < ActionController::API

  private

  private_class_method def self.model
    @model ||= controller_name.classify.constantize
  end

  private_class_method def self.api_version
    @api_version ||= name.split("::")[1].downcase
  end

  def body_params
    ActionController::Parameters.new(JSON.parse(request.body.read))
  end

  def instance_link(instance)
    endpoint = instance.class.name.downcase
    version  = self.class.send(:api_version)
    send("api_#{version}_#{endpoint}_url", instance.id)
  end

  def model
    self.class.send(:model)
  end
end
