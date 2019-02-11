class ApplicationController < ActionController::API
  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from TopologicalInventory::Api::BodyParseError do |exception|
    error_document = TopologicalInventory::Api::ErrorDocument.new.add(400, "Failed to parse POST body, expected JSON")
    render :json => error_document, :status => :bad_request
  end

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
    @body_params ||= begin
      raw_body = request.body.read
      parsed_body = JSON.parse(raw_body)
      ActionController::Parameters.new(parsed_body)
    rescue JSON::ParserError
      raise TopologicalInventory::Api::BodyParseError
    end
  end

  def instance_link(instance)
    endpoint = instance.class.name.underscore
    version  = self.class.send(:api_version)
    send("api_#{version}_#{endpoint}_url", instance.id)
  end

  def params_for_create
    required = api_doc_definition.required_attributes
    body_params.permit(*api_doc_definition.all_attributes).tap { |i| i.require(required) if required }
  end

  def safe_params_for_list
    # :limit & :query can be passed in for pagination purposes, but shouldn't show up as params for filtering purposes
    params.permit(*api_doc_definition.all_attributes + [:limit, :query])
  end

  def params_for_list
    safe_params_for_list.slice(*api_doc_definition.all_attributes)
  end

  def pagination_limit
    safe_params_for_list[:limit]
  end

  def pagination_offset
    safe_params_for_list[:offset]
  end

  def params_for_update
    body_params.permit(*api_doc_definition.all_attributes - api_doc_definition.read_only_attributes)
  end

  def api_doc_definition
    self.class.send(:api_doc_definition)
  end

  def model
    self.class.send(:model)
  end
end
