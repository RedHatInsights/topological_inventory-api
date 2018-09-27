class AddContainerModels < ActiveRecord::Migration[5.0]
  def change
    create_table "container_groups", :id => :bigserial do |t|
      t.references "source", :type => :bigint, :index => true
      t.string     "source_ref"
      t.string     "resource_version"
      t.string     "name"
      t.references "container_project", :type => :bigint, :index => true
      t.string     "ipaddress"
      t.timestamps
      t.datetime   "deleted_at", :index => true
      t.index      %i(source_id source_ref), :unique => true
    end

    create_table "container_projects", :id => :bigserial do |t|
      t.references "source", :type => :bigint, :index => true
      t.string     "source_ref"
      t.string     "resource_version"
      t.string     "name"
      t.string     "display_name"
      t.timestamps
      t.datetime   "deleted_at", :index => true
      t.index      %i(source_id source_ref), :unique => true
    end

    create_table "container_templates", :id => :bigserial do |t|
      t.references "source", :type => :bigint, :index => true
      t.string     "source_ref"
      t.string     "resource_version"
      t.references "container_project", :type => :bigint, :index => true
      t.timestamps
      t.datetime   "deleted_at", :index => true
      t.index      %i(source_id source_ref), :unique => true
    end
  end
end
