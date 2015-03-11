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

ActiveRecord::Schema.define(version: 20150310202044) do

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "researchers", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scenario_step_feelings", force: :cascade do |t|
    t.integer  "scenario_step_id"
    t.integer  "feeling"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.float    "feeling_at_seconds"
    t.text     "context_transcription"
    t.integer  "user_id"
  end

  create_table "scenario_step_results", force: :cascade do |t|
    t.integer  "scenario_step_id"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer  "completed_seconds"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "user_id"
  end

  create_table "scenario_step_videos", force: :cascade do |t|
    t.integer  "scenario_step_id"
    t.text     "transcription_json"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "user_id"
  end

  create_table "scenario_steps", force: :cascade do |t|
    t.integer  "scenario_id"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "step_order"
  end

  create_table "scenarios", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "company_id"
    t.integer  "created_by"
    t.integer  "user_count"
    t.integer  "user_completed_count"
    t.integer  "status"
  end

  create_table "template_steps", force: :cascade do |t|
    t.integer  "template_id"
    t.text     "step_description"
    t.integer  "step_order"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "templates", force: :cascade do |t|
    t.string   "display"
    t.string   "value"
    t.string   "scenario_title"
    t.text     "scenario_description"
    t.integer  "category"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "user_scenarios", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "scenario_id"
    t.integer  "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
