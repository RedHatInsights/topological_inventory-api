class ApplicationController < ActionController::API
  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from TopologicalInventory::Api::BodyParseError do |exception|
    error_document = TopologicalInventory::Api::ErrorDocument.new.add(400, "Failed to parse POST body, expected JSON")
    render :json => error_document, :status => :bad_request
  end

  private
  set_current_tenant_through_filter
  before_action :set_the_current_tenant

  def set_the_current_tenant
    return unless Tenant.tenancy_enabled?

    tenant = Tenant.find_by(:external_tenant => user_identity)
    if tenant
      set_current_tenant(tenant)
    else
      error_document = {
          "errors" => [
              {
                  "status" => "401",
                  "detail" => "Account number not present or not found"
              }
          ]
      }
      render :json => error_document, :status => :unauthorized
    end
  end

  def user_identity
    # "x-rh-identity" => {
    #   "identity" => {
    #     "account_number" => 123456,
    #     "user" => {},
    #     "system" => {},
    #     "internal" => {},
    #     "type" => "String"
    #   }
    # }
    ident_key = "x-rh-identity"
    return unless request.headers.key?(ident_key)

    ident = JSON.parse(Base64.decode64(request.headers[ident_key]))
    ident.fetch_path("identity", "account_number")
  end

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
    # :limit & :offset can be passed in for pagination purposes, but shouldn't show up as params for filtering purposes
    @safe_params_for_list ||= params.merge(params_for_polymorphic_subcollection).permit(*api_doc_definition.all_attributes + [:limit, :offset] + ["#{request_path_parts["primary_collection_name"].singularize}_id"])
  end

  def params_for_polymorphic_subcollection
    return {} unless subcollection?
    return {} unless reflection = primary_collection_model&.reflect_on_association(request_path_parts["subcollection_name"])
    return {} unless as = reflection.options[:as]
    {"#{as}_type" => primary_collection_model.name, "#{as}_id" => request_path_parts["primary_collection_id"]}
  end

  def primary_collection_model
    @primary_collection_model ||= request_path_parts["primary_collection_name"].singularize.classify.safe_constantize
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

  def request_path
    request.env["REQUEST_URI"]
  end

  def request_path_parts
    @request_path_parts ||= request_path.match(/\/(?<full_version_string>v\d+.\d+)\/(?<primary_collection_name>\w+)\/?(?<primary_collection_id>\d+)?\/?(?<subcollection_name>\w+)?/)&.named_captures || {}
  end

  def subcollection?
    !!(request_path_parts["subcollection_name"] && request_path_parts["primary_collection_id"] && request_path_parts["primary_collection_name"])
  end

  def api_doc_definition
    self.class.send(:api_doc_definition)
  end

  def model
    self.class.send(:model)
  end
end
