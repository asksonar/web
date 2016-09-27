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

ActiveRecord::Schema.define(version: 20170927104738) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"
  enable_extension "tablefunc"

  create_table "aircraft", force: :cascade do |t|
    t.string "msn"
    t.string "aircraft_status"
    t.string "aircraft_manufacturer"
    t.string "aircraft_model"
    t.string "aircraft_type"
    t.string "registration"
    t.string "engine_model"
    t.string "engine_variant"
    t.string "operator"
    t.string "operator_country"
    t.string "build_year"
    t.string "aircraft_age"
    t.string "seats_configuration"
    t.string "line_number"
    t.string "aircraft_series"
    t.string "last_delivery_date"
    t.string "operator_region"
    t.string "engine_manufacturer"
    t.string "engine_name"
  end

  create_table "aircraft_histories", force: :cascade do |t|
    t.integer "aircraft_id"
    t.string  "aircraft_model"
    t.string  "aircraft_type"
    t.string  "registration"
    t.string  "delivery_date"
    t.string  "operator_name"
    t.integer "engine_count"
    t.string  "engine_manufacturer"
    t.string  "engine_model"
    t.string  "engine_variant"
    t.string  "seats_configuration"
    t.string  "aircraft_status"
    t.text    "remarks"
    t.string  "engine_name"
  end

  create_table "analysis_views", force: :cascade do |t|
    t.integer  "company_id"
    t.string   "name"
    t.boolean  "default_view"
    t.boolean  "current_view"
    t.text     "pivot_params"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "uuid"
    t.string   "subdomain"
  end

  create_table "customers", force: :cascade do |t|
    t.datetime "first_touch"
    t.datetime "last_touch"
    t.string   "ip_addresses"
    t.string   "region"
    t.string   "country"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "company_id"
    t.string   "email"
    t.hstore   "metadata"
    t.datetime "unsubscribed_at"
  end

  add_index "customers", ["company_id", "email"], name: "index_customers_on_company_id_and_email", using: :btree

  create_table "datatable_views", force: :cascade do |t|
    t.text     "datatable_columns"
    t.integer  "company_id"
    t.string   "name"
    t.boolean  "default_view"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.text     "datatable_filters"
    t.boolean  "current_view"
  end

  create_table "fleets_backup", force: :cascade do |t|
    t.text    "aircraft_status"
    t.text    "aircraft_manufacturer"
    t.text    "aircraft_type"
    t.text    "aircraft_series"
    t.text    "aircraft_variant"
    t.text    "registration"
    t.text    "serial_number"
    t.text    "line_number"
    t.integer "build_year"
    t.text    "operator"
    t.text    "owner"
    t.text    "owner_type"
    t.text    "engine_type"
    t.text    "engine_variant"
    t.text    "seat_total"
    t.text    "mtow"
    t.text    "hours_cumulative"
    t.text    "cycles_cumulative"
    t.text    "effective_date"
    t.text    "aircraft_age"
    t.text    "original_operator"
    t.text    "operated_for"
    t.text    "aircraft_usage"
    t.text    "aircraft_usage2"
    t.text    "minor_variant"
    t.text    "operator_area"
    t.text    "operator_country"
    t.text    "operator_state"
    t.text    "current_market_value"
    t.text    "current_market_lease_rate"
    t.text    "financier1"
    t.text    "noise_category"
    t.text    "manager"
  end

  create_table "metadata_transaction_entries", force: :cascade do |t|
    t.integer  "metadata_transaction_id"
    t.integer  "company_id"
    t.string   "email"
    t.hstore   "metadata"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "metadata_transaction_entries", ["metadata_transaction_id"], name: "index_metadata_transaction_entries_on_metadata_transaction_id", using: :btree

  create_table "metadata_transactions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "panelists", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "responses", force: :cascade do |t|
    t.integer  "customer_id"
    t.integer  "rating"
    t.text     "text"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "uuid"
    t.string   "ip_address"
    t.integer  "status"
    t.integer  "nps"
    t.integer  "date_yyyymmdd"
    t.integer  "survey_type"
  end

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
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "scenario_result_id"
    t.integer  "status_backup"
    t.text     "first_transcription_backup"
    t.integer  "total_delighted_backup"
    t.integer  "total_confused_backup"
    t.float    "offset_seconds"
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
    t.integer  "created_by"
    t.string   "title"
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

  create_table "survey_settings", force: :cascade do |t|
    t.integer  "survey_frequency"
    t.integer  "company_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "style_elements"
    t.integer  "email_followup"
    t.integer  "survey_type"
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

  create_table "touches", force: :cascade do |t|
    t.integer  "customer_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "date_yyyymmdd"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "company_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "full_name"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "role"
    t.boolean  "has_v1"
    t.boolean  "has_v2"
    t.datetime "deleted_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.boolean  "has_v3"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
