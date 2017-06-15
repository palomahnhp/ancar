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

ActiveRecord::Schema.define(version: 20170612074940) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "adminpack"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "approvals", force: :cascade do |t|
    t.integer  "period_id"
    t.integer  "unit_id"
    t.text     "comment"
    t.string   "approval_by"
    t.date     "approval_at"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "official_position"
  end

  add_index "approvals", ["period_id"], name: "index_approvals_on_period_id", using: :btree
  add_index "approvals", ["unit_id"], name: "index_approvals_on_unit_id", using: :btree

  create_table "assigned_employees", force: :cascade do |t|
    t.integer  "official_group_id"
    t.integer  "staff_of_id"
    t.string   "staff_of_type"
    t.integer  "unit_id"
    t.string   "updated_by"
    t.decimal  "quantity",             precision: 5, scale: 2
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "period_id"
    t.text     "justification"
    t.date     "justified_at"
    t.string   "justified_by"
    t.boolean  "pending_verification"
    t.date     "verified_at"
    t.string   "verified_by"
  end

  add_index "assigned_employees", ["official_group_id"], name: "index_assigned_employees_on_official_group_id", using: :btree
  add_index "assigned_employees", ["period_id"], name: "index_assigned_employees_on_period_id", using: :btree
  add_index "assigned_employees", ["unit_id"], name: "index_assigned_employees_on_unit_id", using: :btree

  create_table "assigned_employees_changes", force: :cascade do |t|
    t.integer "period_id"
    t.integer "unit_id"
    t.text    "justification"
    t.date    "justified_at"
    t.string  "justified_by"
    t.date    "verified_at"
    t.string  "verified_by"
  end

  add_index "assigned_employees_changes", ["period_id"], name: "index_assigned_employees_changes_on_period_id", using: :btree
  add_index "assigned_employees_changes", ["unit_id"], name: "index_assigned_employees_changes_on_unit_id", using: :btree
  add_index "assigned_employees_changes", ["verified_at"], name: "index_assigned_employees_changes_on_verified_at", using: :btree

  create_table "docs", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "url"
    t.string   "format"
    t.string   "role"
    t.string   "updated_by"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "entry_indicators", force: :cascade do |t|
    t.integer  "unit_id"
    t.integer  "indicator_metric_id"
    t.integer  "indicator_source_id"
    t.text     "specifications"
    t.decimal  "amount",              precision: 15, scale: 2
    t.string   "updated_by"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "period_id"
  end

  add_index "entry_indicators", ["indicator_metric_id"], name: "index_entry_indicators_on_indicator_metric_id", using: :btree
  add_index "entry_indicators", ["indicator_source_id"], name: "index_entry_indicators_on_indicator_source_id", using: :btree
  add_index "entry_indicators", ["period_id"], name: "index_entry_indicators_on_period_id", using: :btree
  add_index "entry_indicators", ["unit_id"], name: "index_entry_indicators_on_unit_id", using: :btree

  create_table "indicator_groups", force: :cascade do |t|
    t.string   "updated_by"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "item_id"
    t.integer  "order"
    t.integer  "sub_process_id"
  end

  add_index "indicator_groups", ["item_id"], name: "index_indicator_groups_on_item_id", using: :btree
  add_index "indicator_groups", ["sub_process_id"], name: "index_indicator_groups_on_sub_process_id", using: :btree

  create_table "indicator_metrics", force: :cascade do |t|
    t.integer "indicator_id"
    t.integer "metric_id"
    t.string  "order"
  end

  add_index "indicator_metrics", ["indicator_id"], name: "index_indicator_metrics_on_indicator_id", using: :btree
  add_index "indicator_metrics", ["metric_id"], name: "index_indicator_metrics_on_metric_id", using: :btree

  create_table "indicator_sources", force: :cascade do |t|
    t.integer "indicator_id"
    t.integer "source_id"
    t.integer "indicator_metric_id"
  end

  add_index "indicator_sources", ["indicator_id"], name: "index_indicator_sources_on_indicator_id", using: :btree
  add_index "indicator_sources", ["indicator_metric_id"], name: "index_indicator_sources_on_indicator_metric_id", using: :btree
  add_index "indicator_sources", ["source_id"], name: "index_indicator_sources_on_source_id", using: :btree

  create_table "indicators", force: :cascade do |t|
    t.integer  "task_id"
    t.integer  "item_id"
    t.integer  "order"
    t.string   "updated_by"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "description"
  end

  add_index "indicators", ["item_id"], name: "index_indicators_on_item_id", using: :btree
  add_index "indicators", ["task_id"], name: "index_indicators_on_task_id", using: :btree

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
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "organization_id"
  end

  add_index "main_processes", ["item_id"], name: "index_main_processes_on_item_id", using: :btree
  add_index "main_processes", ["organization_id"], name: "index_main_processes_on_organization_id", using: :btree
  add_index "main_processes", ["period_id"], name: "index_main_processes_on_period_id", using: :btree

  create_table "metrics", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "metrics", ["item_id"], name: "index_metrics_on_item_id", using: :btree

  create_table "official_groups", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

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
    t.integer  "order"
    t.string   "updated_by"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "organizations", ["organization_type_id"], name: "index_organizations_on_organization_type_id", using: :btree

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

  create_table "process_names", force: :cascade do |t|
    t.integer  "organization_type_id"
    t.string   "model"
    t.string   "name"
    t.string   "updated_by"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "process_names", ["organization_type_id"], name: "index_process_names_on_organization_type_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string "key"
    t.string "value"
  end

  create_table "sources", force: :cascade do |t|
    t.integer  "item_id"
    t.boolean  "fixed"
    t.boolean  "has_specification"
    t.integer  "order"
    t.string   "updated_by"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.boolean  "imported"
  end

  add_index "sources", ["item_id"], name: "index_sources_on_item_id", using: :btree

  create_table "sub_processes", force: :cascade do |t|
    t.integer  "main_process_id"
    t.integer  "unit_type_id"
    t.integer  "item_id"
    t.string   "order_char"
    t.string   "updated_by"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "order"
  end

  add_index "sub_processes", ["item_id"], name: "index_sub_processes_on_item_id", using: :btree
  add_index "sub_processes", ["main_process_id"], name: "index_sub_processes_on_main_process_id", using: :btree
  add_index "sub_processes", ["unit_type_id"], name: "index_sub_processes_on_unit_type_id", using: :btree

  create_table "summary_process_details", force: :cascade do |t|
    t.integer  "summary_process_id"
    t.integer  "unit_id"
    t.integer  "sub_process_id"
    t.decimal  "amount",             precision: 12, scale: 2
    t.decimal  "A1",                 precision: 5,  scale: 2
    t.decimal  "A2",                 precision: 5,  scale: 2
    t.decimal  "C1",                 precision: 5,  scale: 2
    t.decimal  "C2",                 precision: 5,  scale: 2
    t.decimal  "E",                  precision: 5,  scale: 2
    t.string   "updated_by"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "summary_process_details", ["sub_process_id"], name: "index_summary_process_details_on_sub_process_id", using: :btree
  add_index "summary_process_details", ["summary_process_id"], name: "index_summary_process_details_on_summary_process_id", using: :btree
  add_index "summary_process_details", ["unit_id"], name: "index_summary_process_details_on_unit_id", using: :btree

  create_table "summary_process_indicators", force: :cascade do |t|
    t.integer  "summary_process_id"
    t.string   "indicator"
    t.string   "metric"
    t.string   "updated_by"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "summary_process_indicators", ["summary_process_id"], name: "index_summary_process_indicators_on_summary_process_id", using: :btree

  create_table "summary_processes", force: :cascade do |t|
    t.integer  "process_id"
    t.string   "process_type"
    t.string   "process_description"
    t.integer  "period_id"
    t.string   "updated_by"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "summary_types", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "acronym"
    t.integer  "order"
    t.string   "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "active"
  end

  add_index "summary_types", ["item_id"], name: "index_summary_types_on_item_id", using: :btree

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

  create_table "total_indicator_types", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "acronym"
    t.integer  "order"
    t.boolean  "active"
    t.string   "updated_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "total_indicator_types", ["item_id"], name: "index_total_indicator_types_on_item_id", using: :btree

  create_table "total_indicators", force: :cascade do |t|
    t.integer  "indicator_metric_id"
    t.integer  "indicator_group_id"
    t.string   "indicator_type"
    t.string   "updated_by"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "in_out"
    t.integer  "summary_type_id"
  end

  add_index "total_indicators", ["in_out"], name: "index_total_indicators_on_in_out", using: :btree
  add_index "total_indicators", ["indicator_group_id"], name: "index_total_indicators_on_indicator_group_id", using: :btree
  add_index "total_indicators", ["indicator_metric_id"], name: "index_total_indicators_on_indicator_metric_id", using: :btree
  add_index "total_indicators", ["summary_type_id"], name: "index_total_indicators_on_summary_type_id", using: :btree

  create_table "unit_types", force: :cascade do |t|
    t.integer  "organization_type_id"
    t.string   "description"
    t.string   "updated_by"
    t.integer  "order"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "unit_types", ["organization_type_id"], name: "index_unit_types_on_organization_type_id", using: :btree

  create_table "units", force: :cascade do |t|
    t.integer  "unit_type_id"
    t.integer  "organization_id"
    t.string   "description_sap"
    t.integer  "sap_id"
    t.integer  "order"
    t.string   "updated_by"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "units", ["organization_id"], name: "index_units_on_organization_id", using: :btree
  add_index "units", ["unit_type_id"], name: "index_units_on_unit_type_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.integer  "uweb_id"
    t.string   "name"
    t.string   "surname"
    t.string   "second_surname"
    t.string   "document_number"
    t.string   "document_type"
    t.integer  "pernr"
    t.string   "phone"
    t.string   "official_position"
    t.string   "email"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "role"
    t.datetime "inactivated_at"
    t.integer  "organization_id"
    t.integer  "sap_id_unit"
    t.string   "sap_den_unit"
    t.integer  "sap_id_organization"
    t.string   "sap_den_organization"
    t.date     "uweb_auth_at"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

  add_foreign_key "approvals", "periods"
  add_foreign_key "approvals", "units"
  add_foreign_key "assigned_employees", "official_groups"
  add_foreign_key "assigned_employees", "periods"
  add_foreign_key "assigned_employees", "units"
  add_foreign_key "assigned_employees_changes", "periods"
  add_foreign_key "assigned_employees_changes", "units"
  add_foreign_key "entry_indicators", "indicator_metrics"
  add_foreign_key "entry_indicators", "indicator_sources"
  add_foreign_key "entry_indicators", "periods"
  add_foreign_key "entry_indicators", "units"
  add_foreign_key "indicator_groups", "items"
  add_foreign_key "indicator_groups", "sub_processes"
  add_foreign_key "indicator_metrics", "indicators"
  add_foreign_key "indicator_metrics", "metrics"
  add_foreign_key "indicator_sources", "indicator_metrics"
  add_foreign_key "indicator_sources", "indicators"
  add_foreign_key "indicator_sources", "sources"
  add_foreign_key "indicators", "items"
  add_foreign_key "indicators", "tasks"
  add_foreign_key "main_processes", "items"
  add_foreign_key "main_processes", "organizations"
  add_foreign_key "main_processes", "periods"
  add_foreign_key "metrics", "items"
  add_foreign_key "organizations", "organization_types"
  add_foreign_key "periods", "organization_types"
  add_foreign_key "process_names", "organization_types"
  add_foreign_key "sources", "items"
  add_foreign_key "sub_processes", "items"
  add_foreign_key "sub_processes", "main_processes"
  add_foreign_key "sub_processes", "unit_types"
  add_foreign_key "summary_process_details", "sub_processes"
  add_foreign_key "summary_process_details", "summary_processes"
  add_foreign_key "summary_process_details", "units"
  add_foreign_key "summary_process_indicators", "summary_processes"
  add_foreign_key "summary_types", "items"
  add_foreign_key "tasks", "items"
  add_foreign_key "tasks", "sub_processes"
  add_foreign_key "total_indicator_types", "items"
  add_foreign_key "total_indicators", "indicator_groups"
  add_foreign_key "total_indicators", "indicator_metrics"
  add_foreign_key "total_indicators", "summary_types"
  add_foreign_key "unit_types", "organization_types"
  add_foreign_key "units", "organizations"
  add_foreign_key "units", "unit_types"
end
