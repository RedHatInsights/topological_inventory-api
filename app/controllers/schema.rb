ContainerType = GraphQL::ObjectType.define do
  name "Container"
  description "A Container"

  field "id", !types.String
  field "name", !types.String
  field "archived_at", types.String
  field "container_group_id", types.String
  field "container_image_id", types.String
  field "cpu_limit", types.Float
  field "cpu_request", types.Float
  field "created_at", !types.String
  field "last_seen_at", types.String
  field "memory_limit", types.Float
  field "memory_request", types.Float
  field "updated_at", types.String
end

ContainerGroupType = GraphQL::ObjectType.define do
  name "ContainerGroup"
  description "A Container Group"

  field "source_id",  types.Int
  field "source_ref", types.String
  field "resource_version", types.String
  field "name", types.String
  field "container_project_id", types.Int
  field "ipaddress", types.String
  field "created_at", !types.String
  field "updated_at", types.String
  field "source_deleted_at", types.String
  field "tenant_id", types.Int
  field "container_node_id", types.Int
  field "resource_timestamp", types.String
  field "resource_timestamps", types.String
  field "last_seen_at", types.String
end

ContainerImageType = GraphQL::ObjectType.define do
  name "ContainerImage"
  description "A Container Image"

  field "name", types.String
  field "tenant_id", types.Int
  field "source_id", types.Int
  field "source_ref", types.String
  field "resource_version", types.String
  field "tag", types.String
  field "created_at", !types.String
  field "updated_at", types.String
  field "archived_at", types.String
  field "last_seen_at", types.String
  field "source_deleted_at", types.String
  field "source_created_at", types.String
  field "resource_timestamp", types.String
  field "resource_timestamps", types.String
  field "resource_timestamps_max", types.String
end

QueryType = GraphQL::ObjectType.define do
  name "Query"
  description "The query root of this schema"

  [
    [Container, ContainerType, :containers],
    [ContainerGroup, ContainerGroupType, :container_groups],
    [ContainerImage, ContainerImageType, :container_images]
  ].each do |schema_definition|

    model_class, resource_type, collection = schema_definition

    field collection do
      type types[resource_type]
      argument :id, types.String
      description model_class.name.pluralize
      resolve lambda { |_obj, args, _ctx|
        args[:id] ? model_class.where(:id => args[:id]) : model_class.all
      }
    end
  end
end

Schema = GraphQL::Schema.define do
  query QueryType
end
