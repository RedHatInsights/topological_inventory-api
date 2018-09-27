class AddServiceCatalogModels < ActiveRecord::Migration[5.0]
  def change
    create_table "service_instances", :id => :bigserial do |t|
      t.references "source", :type => :bigint, :index => true
      t.string     "source_ref"
      t.string     "name"
      t.references "service_offering", :type => :bigint, :index => true
      t.references "service_parameters_set", :type => :bigint, :index => true
      t.jsonb      "extra"
      t.timestamps
      t.datetime   "deleted_at", :index => true
      t.index      %i(source_id source_ref), :unique => true
    end

    create_table "service_offerings", :id => :bigserial do |t|
      t.references "source", :type => :bigint, :index => true
      t.string     "source_ref"
      t.string     "name"
      t.text       "description"
      t.jsonb      "extra"
      t.timestamps
      t.datetime   "deleted_at", :index => true
      t.index      %i(source_id source_ref), :unique => true
    end

    create_table "service_parameters_sets", :id => :bigserial do |t|
      t.references "source", :type => :bigint, :index => true
      t.string     "source_ref"
      t.string     "name"
      t.text       "description"
      t.references "service_offering", :type => :bigint, :index => true
      t.jsonb      "extra"
      t.timestamps
      t.datetime   "deleted_at", :index => true
      t.index      %i(source_id source_ref), :unique => true
    end
  end
end
