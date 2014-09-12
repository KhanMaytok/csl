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

ActiveRecord::Schema.define(version: 20140910114539) do

  create_table "areas", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", force: true do |t|
    t.integer  "patient_id"
    t.integer  "money_id"
    t.integer  "clinic_id"
    t.string   "code"
    t.datetime "date"
    t.integer  "status_id"
    t.integer  "doctor_id"
    t.boolean  "has_record"
    t.integer  "consultations_quantity"
    t.text     "symptoms"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "benefits", force: true do |t|
    t.integer  "pay_document_id"
    t.integer  "correlative"
    t.integer  "document_type_id"
    t.string   "second_document_code"
    t.integer  "sub_coverage_fact_type_id"
    t.date     "date"
    t.time     "time"
    t.float    "expense_fee",                    limit: 24
    t.float    "expense_dental",                 limit: 24
    t.float    "expense_hotelery",               limit: 24
    t.float    "expense_aux_lab",                limit: 24
    t.float    "expense_aux_img",                limit: 24
    t.float    "expense_pharmacy",               limit: 24
    t.float    "expense_prosthesis",             limit: 24
    t.float    "expense_medicaments_exonerated", limit: 24
    t.float    "cop_fijo",                       limit: 24
    t.string   "cop_var"
    t.string   "float"
    t.float    "total_expense",                  limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clasification_service_types", force: true do |t|
    t.string   "code"
    t.string   "name"
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

  create_table "coverage_fact_types", force: true do |t|
    t.string   "code"
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

  create_table "cum_sunasa_products", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "form"
    t.string   "owner"
    t.string   "manufacturer"
    t.string   "report_unity"
    t.string   "measure"
    t.string   "measure_unity"
    t.string   "posologic_unity"
    t.string   "atc_code_atc_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "detail_pharmacies", force: true do |t|
    t.integer  "benefit_id"
    t.integer  "correlative"
    t.integer  "product_pharmacy_type_id"
    t.integer  "cum_sunasa_product_id"
    t.integer  "medical_input_id"
    t.integer  "digemid_product_id"
    t.integer  "ean_product_id"
    t.date     "dispensation_date"
    t.integer  "quantity"
    t.float    "unit_amount",              limit: 24
    t.float    "copayment",                limit: 24
    t.float    "amount",                   limit: 24
    t.float    "amount_not_covered",       limit: 24
    t.string   "diagnostic_code"
    t.integer  "product_pharm_exented_id"
    t.integer  "guide_pharmacy"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "detail_services", force: true do |t|
    t.integer  "benefit_id"
    t.integer  "correlative"
    t.integer  "clasification_service_type_id"
    t.integer  "nomenclator_service_id"
    t.date     "date"
    t.integer  "quantity"
    t.float    "unit_amount",                   limit: 24
    t.float    "copayment",                     limit: 24
    t.float    "amount",                        limit: 24
    t.float    "amount_not_covered",            limit: 24
    t.string   "diagnostic_code"
    t.integer  "service_exented_id"
    t.integer  "sector_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diagnostic_categories", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "diagnostic_types", force: true do |t|
    t.integer  "diagnostic_category_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "digemid_products", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "concentration"
    t.string   "form"
    t.string   "form_simplificated"
    t.string   "presentation"
    t.date     "due_date_sanitary"
    t.string   "sanitary_number"
    t.string   "holder_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "doctors", force: true do |t|
    t.integer  "speciality_id"
    t.string   "tuition_code"
    t.string   "dni"
    t.string   "card_number"
    t.string   "name"
    t.string   "paternal"
    t.string   "maternal"
    t.float    "to_clinic",     limit: 24
    t.float    "to_doctor",     limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_identity_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "document_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drugs_tore_details", force: true do |t|
    t.integer  "drugstore_attention_id"
    t.integer  "drugstore_product_id"
    t.integer  "quantity"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drugstore_attentions", force: true do |t|
    t.integer  "authorization_id"
    t.date     "date"
    t.time     "time"
    t.integer  "doctor_id"
    t.string   "amount"
    t.string   "float"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drugstore_histories", force: true do |t|
    t.integer  "drugstore_product_id"
    t.date     "date"
    t.float    "price",                limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "drugstore_products", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.float    "actual_price", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ean_products", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "concentration"
    t.string   "form"
    t.string   "form_simplificated"
    t.string   "presentation"
    t.string   "fractions"
    t.date     "due_date_sanitary"
    t.string   "number_sanitary"
    t.string   "holder_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employees", force: true do |t|
    t.string   "name"
    t.string   "paternal"
    t.string   "maternal"
    t.string   "username"
    t.integer  "area_id"
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
    t.string   "fact_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "insured_radiograph_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.float    "price",        limit: 24
    t.float    "cop_fijo",     limit: 24
    t.float    "cop_var",      limit: 24
    t.float    "porc_cop_var", limit: 24
    t.integer  "insurance_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "insured_radiographs", force: true do |t|
    t.integer  "radiograph_id"
    t.date     "date"
    t.time     "time"
    t.integer  "doctor_id"
    t.integer  "insured_radiograph_type_id"
    t.float    "cop_fijo",                   limit: 24
    t.float    "cop_var",                    limit: 24
    t.string   "ticket_code"
    t.float    "amount",                     limit: 24
    t.integer  "administration_id"
    t.integer  "admission_id"
    t.boolean  "is_printed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "insureds", force: true do |t|
    t.integer  "afiliation_type_id"
    t.integer  "company_id"
    t.integer  "insurance_id"
    t.integer  "patient_id"
    t.string   "code"
    t.string   "hold_paternal"
    t.string   "hold_name"
    t.date     "validity_id"
    t.date     "validity_f"
    t.date     "inclusion_date"
    t.integer  "relation_ship_id"
    t.string   "card_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mechanism_payments", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "medical_inputs", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "money", force: true do |t|
    t.string   "code"
    t.string   "fact_code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nomenclator_services", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "contable_group"
    t.string   "contable_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "note_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.integer  "note_type_id"
    t.float    "amount",          limit: 24
    t.string   "number"
    t.date     "date"
    t.integer  "reason_id"
    t.integer  "pay_document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "particular_radiograph_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.float    "price",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "particular_radiographs", force: true do |t|
    t.string   "radiograph_id"
    t.date     "date"
    t.time     "time"
    t.integer  "doctor_id"
    t.integer  "particular_radiograph_type_id"
    t.integer  "employee_id"
    t.boolean  "is_printed"
    t.string   "ticket_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "patients", force: true do |t|
    t.integer  "document_identity_type_id"
    t.string   "document_identity_code"
    t.string   "name"
    t.string   "paternal"
    t.string   "maternal"
    t.date     "birthday"
    t.string   "age"
    t.string   "sex"
    t.integer  "employee_id"
    t.string   "clinic_history_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pay_document_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pay_documents", force: true do |t|
    t.integer  "authorization_id"
    t.string   "pay_document_type_id"
    t.string   "code"
    t.string   "emission_date"
    t.integer  "product_code_id"
    t.integer  "benefits_quantity"
    t.integer  "sub_mechanism_pay_type_id"
    t.float    "pre_agreed",                 limit: 24
    t.date     "init_pre_agreed_date"
    t.float    "amount_medicine_exonerated", limit: 24
    t.float    "total_cop_fijo",             limit: 24
    t.float    "total_cop_var",              limit: 24
    t.float    "net_amount",                 limit: 24
    t.float    "igv",                        limit: 24
    t.float    "total_amount",               limit: 24
    t.integer  "indicator_global_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_pharm_exenteds", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_pharmacy_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "radiographs", force: true do |t|
    t.integer  "authorization_id"
    t.boolean  "is_insured"
    t.float    "amount",           limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reasons", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relation_ships", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sectors", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_exenteds", force: true do |t|
    t.string   "code"
    t.string   "name"
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

  create_table "specialities", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_coverage_fact_types", force: true do |t|
    t.integer  "coverage_fact_type_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_mechanism_pay_types", force: true do |t|
    t.integer  "mechanism_payment_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ultrasound_attentions", force: true do |t|
    t.integer  "authorization_id"
    t.float    "amount",           limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ultrasound_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.float    "price",      limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ultrasounds", force: true do |t|
    t.integer  "ultrasound_attention_id"
    t.integer  "ultrasound_type_id"
    t.float    "cop_fijo",                limit: 24
    t.float    "cop_var",                 limit: 24
    t.float    "amount",                  limit: 24
    t.string   "ticket_code"
    t.date     "date"
    t.time     "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
