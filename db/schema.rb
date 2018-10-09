# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20181002195506) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", id: :bigserial, force: :cascade do |t|
    t.string  "resource_type"
    t.integer "resource_id"
    t.string  "name"
    t.string  "authtype"
    t.string  "userid"
    t.string  "password"
    t.string  "status"
    t.string  "status_details"
    t.index ["resource_type", "resource_id"], name: "index_authentications_on_resource_type_and_resource_id", using: :btree
  end

  create_table "container_groups", id: :bigserial, force: :cascade do |t|
    t.bigint   "source_id"
    t.string   "source_ref"
    t.string   "resource_version"
    t.string   "name"
    t.bigint   "container_project_id"
    t.string   "ipaddress"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "deleted_at"
    t.index ["container_project_id"], name: "index_container_groups_on_container_project_id", using: :btree
    t.index ["deleted_at"], name: "index_container_groups_on_deleted_at", using: :btree
    t.index ["source_id", "source_ref"], name: "index_container_groups_on_source_id_and_source_ref", unique: true, using: :btree
    t.index ["source_id"], name: "index_container_groups_on_source_id", using: :btree
  end

  create_table "container_projects", id: :bigserial, force: :cascade do |t|
    t.bigint   "source_id"
    t.string   "source_ref"
    t.string   "resource_version"
    t.string   "name"
    t.string   "display_name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_container_projects_on_deleted_at", using: :btree
    t.index ["source_id", "source_ref"], name: "index_container_projects_on_source_id_and_source_ref", unique: true, using: :btree
    t.index ["source_id"], name: "index_container_projects_on_source_id", using: :btree
  end

  create_table "container_templates", id: :bigserial, force: :cascade do |t|
    t.bigint   "source_id"
    t.string   "source_ref"
    t.string   "resource_version"
    t.bigint   "container_project_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "deleted_at"
    t.index ["container_project_id"], name: "index_container_templates_on_container_project_id", using: :btree
    t.index ["deleted_at"], name: "index_container_templates_on_deleted_at", using: :btree
    t.index ["source_id", "source_ref"], name: "index_container_templates_on_source_id_and_source_ref", unique: true, using: :btree
    t.index ["source_id"], name: "index_container_templates_on_source_id", using: :btree
  end

  create_table "endpoints", id: :bigserial, force: :cascade do |t|
    t.string   "role"
    t.integer  "port"
    t.bigint   "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "default"
    t.string   "scheme"
    t.string   "host"
    t.string   "path"
    t.index ["source_id"], name: "index_endpoints_on_source_id", using: :btree
  end

  create_table "service_instances", id: :bigserial, force: :cascade do |t|
    t.bigint   "source_id"
    t.string   "source_ref"
    t.string   "name"
    t.bigint   "service_offering_id"
    t.bigint   "service_parameters_set_id"
    t.jsonb    "extra"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_service_instances_on_deleted_at", using: :btree
    t.index ["service_offering_id"], name: "index_service_instances_on_service_offering_id", using: :btree
    t.index ["service_parameters_set_id"], name: "index_service_instances_on_service_parameters_set_id", using: :btree
    t.index ["source_id", "source_ref"], name: "index_service_instances_on_source_id_and_source_ref", unique: true, using: :btree
    t.index ["source_id"], name: "index_service_instances_on_source_id", using: :btree
  end

  create_table "service_offerings", id: :bigserial, force: :cascade do |t|
    t.bigint   "source_id"
    t.string   "source_ref"
    t.string   "name"
    t.text     "description"
    t.jsonb    "extra"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_service_offerings_on_deleted_at", using: :btree
    t.index ["source_id", "source_ref"], name: "index_service_offerings_on_source_id_and_source_ref", unique: true, using: :btree
    t.index ["source_id"], name: "index_service_offerings_on_source_id", using: :btree
  end

  create_table "service_parameters_sets", id: :bigserial, force: :cascade do |t|
    t.bigint   "source_id"
    t.string   "source_ref"
    t.string   "name"
    t.text     "description"
    t.bigint   "service_offering_id"
    t.jsonb    "extra"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_service_parameters_sets_on_deleted_at", using: :btree
    t.index ["service_offering_id"], name: "index_service_parameters_sets_on_service_offering_id", using: :btree
    t.index ["source_id", "source_ref"], name: "index_service_parameters_sets_on_source_id_and_source_ref", unique: true, using: :btree
    t.index ["source_id"], name: "index_service_parameters_sets_on_source_id", using: :btree
  end

  create_table "sources", id: :bigserial, force: :cascade do |t|
    t.string   "name"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
