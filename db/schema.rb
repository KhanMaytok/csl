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

ActiveRecord::Schema.define(version: 20140908030148) do

  create_table "afiliation_types", force: true do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", force: true do |t|
    t.integer  "insured_id"
    t.integer  "money_id"
    t.integer  "clinic_id"
    t.string   "code"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clinics", force: true do |t|
    t.string   "code"
    t.string   "ruc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", force: true do |t|
    t.string   "number"
    t.string   "ruc"
    t.string   "plan"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coverage_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coverages", force: true do |t|
    t.integer  "authorization_id"
    t.integer  "coverage_type_id"
    t.integer  "service_id"
    t.float    "cop_fijo",            limit: 24
    t.float    "cop_var",             limit: 24
    t.integer  "quantity"
    t.string   "procedure_indicator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diagnostic_categories", force: true do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diagnostics", force: true do |t|
    t.integer  "diagnostic_category_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "exclusions", force: true do |t|
    t.integer  "authorization_id"
    t.integer  "diagnostic_id"
    t.text     "observation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "insurances", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "insureds", force: true do |t|
    t.integer  "afiliation_type_id"
    t.integer  "company_id"
    t.integer  "insurance_id"
    t.string   "code"
    t.string   "dni"
    t.string   "paternal"
    t.string   "maternal"
    t.string   "name"
    t.string   "hold_paternal"
    t.string   "hold_maternal"
    t.string   "hold_name"
    t.string   "birthday"
    t.string   "age"
    t.string   "sex"
    t.date     "validity_i"
    t.date     "validity_f"
    t.date     "inclusion_date"
    t.integer  "relationship_id"
    t.string   "card_number"
    t.text     "observation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "money", force: true do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "procedure_types", force: true do |t|
    t.integer  "insurance_id"
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", force: true do |t|
    t.string   "code"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "special_procedures", force: true do |t|
    t.integer  "authorization_id"
    t.integer  "coverage_type_id"
    t.integer  "procedure_type_id"
    t.float    "deductible",          limit: 24
    t.float    "percentage_coverade", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
