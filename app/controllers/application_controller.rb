class ApplicationController < ActionController::API
  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  private

  private_class_method def self.model
    @model ||= controller_name.classify.constantize
  end

  private_class_method def self.api_doc_definition
    @api_doc_definition ||= Api::Docs[api_version[1..-1].sub(/x/, ".")].definitions[model.name]
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

  def params_for_create
    required = api_doc_definition.required_attributes
    body_params.permit(*api_doc_definition.all_attributes).tap { |i| i.require(required) if required }
  end

  def api_doc_definition
    self.class.send(:api_doc_definition)
  end

  def model
    self.class.send(:model)
  end
end
