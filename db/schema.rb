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

ActiveRecord::Schema.define(version: 20160412062926) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "indicators", force: :cascade do |t|
    t.integer  "task_id"
    t.string   "indicator_int"
    t.integer  "source_id"
    t.integer  "amount"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "indicators", ["source_id"], name: "index_indicators_on_source_id", using: :btree
  add_index "indicators", ["task_id"], name: "index_indicators_on_task_id", using: :btree

  create_table "mainprocesses", force: :cascade do |t|
    t.integer  "period_id"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "mainprocesses", ["period_id"], name: "index_mainprocesses_on_period_id", using: :btree

  create_table "periods", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string "key"
    t.string "value"
  end

  create_table "sources", force: :cascade do |t|
    t.string   "description"
    t.text     "specification"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "subprocesses", force: :cascade do |t|
    t.integer  "mainprocess_id"
    t.string   "description"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "subprocesses", ["mainprocess_id"], name: "index_subprocesses_on_mainprocess_id", using: :btree

  create_table "tasks", force: :cascade do |t|
    t.integer  "subprocess_id"
    t.text     "description"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "tasks", ["subprocess_id"], name: "index_tasks_on_subprocess_id", using: :btree

  add_foreign_key "indicators", "sources"
  add_foreign_key "indicators", "tasks"
  add_foreign_key "mainprocesses", "periods"
  add_foreign_key "subprocesses", "mainprocesses"
  add_foreign_key "tasks", "subprocesses"
end
