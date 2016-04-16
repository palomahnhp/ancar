# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160419164036) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "indicator_sources", force: :cascade do |t|
    t.boolean  "fixed"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "indicator_id"
    t.integer  "source_id"
  end

  add_index "indicator_sources", ["indicator_id"], name: "index_indicator_sources_on_indicator_id", using: :btree
  add_index "indicator_sources", ["source_id"], name: "index_indicator_sources_on_source_id", using: :btree

  create_table "indicators", force: :cascade do |t|
    t.string   "description"
    t.string   "type"
    t.integer  "amount"
    t.string   "updated_by"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "task_id"
  end

  add_index "indicators", ["task_id"], name: "index_indicators_on_task_id", using: :btree

  create_table "main_organizations", force: :cascade do |t|
    t.integer  "type_organization_id"
    t.string   "name"
    t.string   "short_name"
    t.string   "sap_id"
    t.string   "updated_by"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "main_organizations", ["type_organization_id"], name: "index_main_organizations_on_type_organization_id", using: :btree

  create_table "main_processes", force: :cascade do |t|
    t.integer  "order"
    t.string   "description"
    t.string   "updated_by"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "period_id"
  end

  add_index "main_processes", ["period_id"], name: "index_main_processes_on_period_id", using: :btree

  create_table "organization_types", force: :cascade do |t|
    t.string   "acronym"
    t.string   "name"
    t.string   "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "sap_id"
    t.string   "updated_by"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "organization_type_id"
  end

  add_index "organizations", ["organization_type_id"], name: "index_organizations_on_organization_type_id", using: :btree

  create_table "periods", force: :cascade do |t|
    t.string   "name",                 limit: 80
    t.string   "description",          limit: 100
    t.date     "start_at"
    t.date     "end_at"
    t.date     "open_at"
    t.date     "close_at"
    t.string   "updated_by"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "organization_type_id"
  end

  add_index "periods", ["organization_type_id"], name: "index_periods_on_organization_type_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string "key"
    t.string "value"
  end

  create_table "sources", force: :cascade do |t|
    t.string   "name"
    t.boolean  "specification"
    t.string   "updated_by"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "sub_processes", force: :cascade do |t|
    t.integer  "order"
    t.string   "description"
    t.string   "updated_by"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "main_process_id"
  end

  add_index "sub_processes", ["main_process_id"], name: "index_sub_processes_on_main_process_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "order"
    t.text     "description"
    t.string   "updated_by"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "sub_process_id"
  end

  add_index "tasks", ["sub_process_id"], name: "index_tasks_on_sub_process_id", using: :btree

  create_table "unit_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "organization_type_id"
  end

  add_index "unit_types", ["organization_type_id"], name: "index_unit_types_on_organization_type_id", using: :btree

  create_table "units", force: :cascade do |t|
    t.string   "name"
    t.integer  "sap_id"
    t.string   "updated_by"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "organization_id"
    t.integer  "unit_type_id"
  end

  add_index "units", ["organization_id"], name: "index_units_on_organization_id", using: :btree
  add_index "units", ["unit_type_id"], name: "index_units_on_unit_type_id", using: :btree

end
