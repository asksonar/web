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

ActiveRecord::Schema.define(version: 20151106110000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "panelists", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "researchers", force: :cascade do |t|
    t.integer  "company_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "full_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "role"
  end

  add_index "researchers", ["email"], name: "index_researchers_on_email", unique: true, using: :btree
  add_index "researchers", ["reset_password_token"], name: "index_researchers_on_reset_password_token", unique: true, using: :btree

  create_table "result_notes", force: :cascade do |t|
    t.integer  "result_step_id_backup"
    t.float    "offset_seconds"
    t.text     "text"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "scenario_result_id"
    t.float    "offset_seconds_backup"
  end

  create_table "result_steps", force: :cascade do |t|
    t.integer  "scenario_step_id"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.float    "completed_seconds"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "scenario_result_id"
    t.integer  "status"
    t.text     "first_transcription"
    t.integer  "total_delighted"
    t.integer  "total_confused"
  end

  create_table "result_transcriptions", force: :cascade do |t|
    t.float    "offset_seconds"
    t.text     "text"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "result_step_id_backup"
    t.text     "original_text"
    t.integer  "scenario_result_id"
    t.float    "offset_seconds_backup"
  end

  create_table "result_videos", force: :cascade do |t|
    t.integer  "scenario_step_id_backup"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "scenario_result_id"
    t.string   "uuid"
    t.float    "offset_seconds"
    t.float    "length_seconds"
    t.integer  "result_step_id_backup"
    t.integer  "status"
  end

  create_table "scenario_highlights", force: :cascade do |t|
    t.string   "title"
    t.integer  "result_step_id_backup"
    t.float    "start_seconds"
    t.float    "end_seconds"
    t.text     "timeline_elements"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "scenario_id_backup"
    t.integer  "scenario_result_id"
  end

  create_table "scenario_results", force: :cascade do |t|
    t.integer  "panelist_id"
    t.integer  "scenario_id"
    t.integer  "status"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "scenario_steps", force: :cascade do |t|
    t.integer  "scenario_id"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "step_order"
    t.string   "url"
  end

  create_table "scenarios", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "company_id"
    t.integer  "created_by"
    t.integer  "status",       default: 0
    t.datetime "published_at"
    t.datetime "completed_at"
  end

  create_table "step_highlights", force: :cascade do |t|
    t.integer  "scenario_step_id"
    t.integer  "scenario_result_id"
    t.float    "offset_seconds"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.text     "context_transcription"
    t.integer  "result_step_id"
    t.text     "text"
  end

  create_table "template_steps", force: :cascade do |t|
    t.integer  "template_id"
    t.text     "step_description"
    t.integer  "step_order"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "step_url"
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

end
