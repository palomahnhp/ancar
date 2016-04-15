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

ActiveRecord::Schema.define(version: 20160412203514) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "indicators", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "order"
    t.string   "description"
    t.integer  "amount_in"
    t.integer  "amount_out"
    t.string   "fixed_source"
    t.string   "updated_by"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
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
    t.integer  "period_id"
    t.string   "order"
    t.string   "description"
    t.string   "updated_by"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "main_processes", ["period_id"], name: "index_main_processes_on_period_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.integer  "main_organization_id"
    t.integer  "subtype_organization_id"
    t.string   "name"
    t.string   "sap_id"
    t.string   "updated_by"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "organizations", ["main_organization_id"], name: "index_organizations_on_main_organization_id", using: :btree
  add_index "organizations", ["subtype_organization_id"], name: "index_organizations_on_subtype_organization_id", using: :btree

  create_table "periods", force: :cascade do |t|
    t.string   "name",         limit: 80
    t.string   "description",  limit: 100
    t.date     "initial_date"
    t.date     "final_date"
    t.date     "opening_date"
    t.date     "closing_date"
    t.string   "updated_by"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "key"
    t.string "value"
  end

  create_table "sources", force: :cascade do |t|
    t.string   "name"
    t.integer  "order"
    t.boolean  "has_specification"
    t.text     "specification"
    t.string   "updated_by"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "sub_processes", force: :cascade do |t|
    t.integer  "main_process_id"
    t.integer  "order"
    t.string   "description"
    t.string   "updated_by"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "sub_processes", ["main_process_id"], name: "index_sub_processes_on_main_process_id", using: :btree

  create_table "subtype_organizations", force: :cascade do |t|
    t.integer  "type_organization_id"
    t.string   "name"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "subtype_organizations", ["type_organization_id"], name: "index_subtype_organizations_on_type_organization_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "sub_process_id"
    t.string   "order"
    t.text     "description"
    t.string   "updated_by"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "tasks", ["sub_process_id"], name: "index_tasks_on_sub_process_id", using: :btree

  create_table "type_organizations", force: :cascade do |t|
    t.string   "acronym"
    t.string   "name"
    t.string   "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "indicators", "tasks"
  add_foreign_key "main_organizations", "type_organizations"
  add_foreign_key "main_processes", "periods"
  add_foreign_key "organizations", "subtype_organizations"
  add_foreign_key "sub_processes", "main_processes"
  add_foreign_key "subtype_organizations", "type_organizations"
  add_foreign_key "tasks", "sub_processes"
end
