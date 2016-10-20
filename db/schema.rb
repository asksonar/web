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

ActiveRecord::Schema.define(version: 20171020141051) do

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
    t.integer  "aircraft_id"
    t.string   "aircraft_model"
    t.string   "aircraft_type"
    t.string   "registration"
    t.string   "operator_name"
    t.integer  "engine_count"
    t.string   "engine_manufacturer"
    t.string   "engine_model"
    t.string   "engine_variant"
    t.string   "seats_configuration"
    t.string   "aircraft_status"
    t.text     "remarks"
    t.string   "engine_name"
    t.datetime "delivery_date"
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
    t.datetime "deleted_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
