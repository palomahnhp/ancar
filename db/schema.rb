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

ActiveRecord::Schema.define(version: 20160523082121) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entry_indicator_sources", force: :cascade do |t|
    t.integer "entry_indicator_id_id"
    t.integer "source_id"
  end

  add_index "entry_indicator_sources", ["entry_indicator_id_id"], name: "index_entry_indicator_sources_on_entry_indicator_id_id", using: :btree
  add_index "entry_indicator_sources", ["source_id"], name: "index_entry_indicator_sources_on_source_id", using: :btree

  create_table "entry_indicators", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "indicator_id"
    t.text     "specifications"
    t.string   "updated_by"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "amount"
  end

  add_index "entry_indicators", ["indicator_id"], name: "index_entry_indicators_on_indicator_id", using: :btree
  add_index "entry_indicators", ["unit_id"], name: "index_entry_indicators_on_unit_id", using: :btree

  create_table "indicators", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "item_id"
    t.string   "in_out"
    t.integer  "order"
    t.string   "updated_by"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "metric"
    t.integer  "total_process"
    t.integer  "total_sub_process"
  end

  add_index "indicators", ["item_id"], name: "index_indicators_on_item_id", using: :btree
  add_index "indicators", ["task_id"], name: "index_indicators_on_task_id", using: :btree

  create_table "indicators_sources", force: :cascade do |t|
    t.integer "indicator_id"
    t.integer "source_id"
  end

  add_index "indicators_sources", ["indicator_id"], name: "index_indicators_sources_on_indicator_id", using: :btree
  add_index "indicators_sources", ["source_id"], name: "index_indicators_sources_on_source_id", using: :btree

  create_table "items", force: :cascade do |t|
    t.string   "item_type"
    t.string   "description"
    t.string   "updated_by"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "main_processes", force: :cascade do |t|
    t.integer  "period_id"
    t.integer  "item_id"
    t.integer  "order"
    t.string   "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "main_processes", ["item_id"], name: "index_main_processes_on_item_id", using: :btree
  add_index "main_processes", ["period_id"], name: "index_main_processes_on_period_id", using: :btree

  create_table "organization_types", force: :cascade do |t|
    t.string   "acronym"
    t.string   "description"
    t.string   "updated_by"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.integer  "organization_type_id"
    t.string   "description"
    t.string   "short_description"
    t.string   "sap_id"
    t.string   "updated_by"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "periods", force: :cascade do |t|
    t.integer  "organization_type_id"
    t.string   "description",          limit: 100
    t.date     "started_at"
    t.date     "ended_at"
    t.date     "opened_at"
    t.date     "closed_at"
    t.string   "updated_by"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "periods", ["description"], name: "index_periods_on_description", using: :btree
  add_index "periods", ["organization_type_id"], name: "index_periods_on_organization_type_id", using: :btree
  add_index "periods", ["started_at"], name: "index_periods_on_started_at", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string "key"
    t.string "value"
  end

  create_table "sources", force: :cascade do |t|
    t.integer  "indicator_id"
    t.integer  "item_id"
    t.boolean  "fixed"
    t.boolean  "has_specification"
    t.string   "updated_by"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "sources", ["indicator_id"], name: "index_sources_on_indicator_id", using: :btree
  add_index "sources", ["item_id"], name: "index_sources_on_item_id", using: :btree

  create_table "sub_processes", force: :cascade do |t|
    t.integer  "main_process_id"
    t.integer  "unit_type_id"
    t.integer  "item_id"
    t.integer  "order"
    t.string   "updated_by"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "sub_processes", ["item_id"], name: "index_sub_processes_on_item_id", using: :btree
  add_index "sub_processes", ["main_process_id"], name: "index_sub_processes_on_main_process_id", using: :btree
  add_index "sub_processes", ["unit_type_id"], name: "index_sub_processes_on_unit_type_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "sub_process_id"
    t.integer  "item_id"
    t.integer  "order"
    t.string   "updated_by"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "tasks", ["item_id"], name: "index_tasks_on_item_id", using: :btree
  add_index "tasks", ["sub_process_id"], name: "index_tasks_on_sub_process_id", using: :btree

  create_table "unit_types", force: :cascade do |t|
    t.integer  "organization_type_id"
    t.string   "description"
    t.string   "updated_by"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "units", force: :cascade do |t|
    t.integer  "unit_type_id"
    t.integer  "organization_id"
    t.string   "description_sap"
    t.integer  "sap_id"
    t.string   "updated_by"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
