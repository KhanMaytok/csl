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

ActiveRecord::Schema.define(version: 20141109020146) do

  create_table "afiliation_types", force: true do |t|
    t.string   "code"
    t.string   "fac_code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "area_providers", force: true do |t|
    t.integer  "provider_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "clinic_area_id"
  end

  add_index "area_providers", ["clinic_area_id"], name: "index_area_providers_on_clinic_area_id", using: :btree

  create_table "areas", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorization_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", force: true do |t|
    t.integer  "patient_id"
    t.integer  "money_id"
    t.integer  "clinic_id"
    t.integer  "status_id"
    t.integer  "doctor_id"
    t.integer  "product_id"
    t.string   "code"
    t.datetime "date"
    t.boolean  "has_record"
    t.integer  "consultations_quantity"
    t.text     "symptoms"
    t.string   "ruc_transference"
    t.date     "date_transference"
    t.time     "time_transference"
    t.integer  "hospitalization_type_id"
    t.date     "date_intput"
    t.date     "date_output"
    t.integer  "hospitalization_output_type_id"
    t.integer  "hospitalization_days"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "intern_code"
    t.string   "first_diagnostic"
    t.string   "second_diagnostic"
    t.string   "third_diagnostic"
    t.boolean  "has_consultation"
    t.integer  "authorization_type_id"
  end

  add_index "authorizations", ["authorization_type_id"], name: "index_authorizations_on_authorization_type_id", using: :btree
  add_index "authorizations", ["clinic_id"], name: "index_authorizations_on_clinic_id", using: :btree
  add_index "authorizations", ["doctor_id"], name: "index_authorizations_on_doctor_id", using: :btree
  add_index "authorizations", ["hospitalization_output_type_id"], name: "index_authorizations_on_hospitalization_output_type_id", using: :btree
  add_index "authorizations", ["hospitalization_type_id"], name: "index_authorizations_on_hospitalization_type_id", using: :btree
  add_index "authorizations", ["money_id"], name: "index_authorizations_on_money_id", using: :btree
  add_index "authorizations", ["patient_id"], name: "index_authorizations_on_patient_id", using: :btree
  add_index "authorizations", ["product_id"], name: "index_authorizations_on_product_id", using: :btree
  add_index "authorizations", ["status_id"], name: "index_authorizations_on_status_id", using: :btree

  create_table "benefit_groups", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "quantity"
    t.date     "date"
    t.time     "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dental_name"
  end

  create_table "benefits", force: true do |t|
    t.integer  "pay_document_id"
    t.integer  "document_type_id"
    t.integer  "benefit_group_id"
    t.integer  "correlative"
    t.date     "date"
    t.time     "time"
    t.string   "ruc_extern_entity"
    t.date     "transference_date"
    t.time     "transference_time"
    t.string   "hospitalization_type_code"
    t.string   "hospitalization_output_type_code"
    t.date     "admission_date"
    t.date     "discharge_date"
    t.string   "days_hospitalization"
    t.float    "expense_fee",                      limit: 24
    t.float    "expense_dental",                   limit: 24
    t.float    "expense_hotelery",                 limit: 24
    t.float    "expense_aux_lab",                  limit: 24
    t.float    "expense_aux_img",                  limit: 24
    t.float    "expense_pharmacy",                 limit: 24
    t.float    "expense_prosthesis",               limit: 24
    t.float    "expense_medicaments_exonerated",   limit: 24
    t.float    "cop_fijo",                         limit: 24
    t.float    "cop_var",                          limit: 24
    t.float    "total_expense",                    limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_code"
    t.string   "intern_code"
    t.string   "afiliation_type_code"
    t.string   "insured_code"
    t.string   "document_identity_type_code"
    t.string   "document_identity_code"
    t.string   "clinic_history_code"
    t.string   "coverage_type_code"
    t.string   "sub_type_coverage_code"
    t.string   "first_diagnostic"
    t.string   "second_diagnostic"
    t.string   "third_diagnostic"
    t.string   "type_professional_code"
    t.string   "tuition_code"
    t.string   "professional_identity_type_code"
    t.string   "professional_identity_code"
    t.string   "first_authorization_type"
    t.string   "first_authorization_number"
    t.string   "second_authorization_type"
    t.string   "second_authorization_code"
    t.string   "clinic_code"
    t.string   "clinic_ruc"
    t.string   "document_payment_type"
    t.float    "expense_other",                    limit: 24
  end

  add_index "benefits", ["benefit_group_id"], name: "index_benefits_on_benefit_group_id", using: :btree
  add_index "benefits", ["document_type_id"], name: "index_benefits_on_document_type_id", using: :btree
  add_index "benefits", ["pay_document_id"], name: "index_benefits_on_pay_document_id", using: :btree

  create_table "category_possessions", force: true do |t|
    t.integer  "clinic_area_id"
    t.integer  "service_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_services", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clasification_service_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clinic_areas", force: true do |t|
    t.string   "name"
    t.integer  "tedef_area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "clinics", force: true do |t|
    t.string   "code"
    t.string   "fac_code"
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
    t.integer  "sub_coverage_type_id"
    t.string   "code"
    t.string   "name"
    t.float    "cop_fijo",             limit: 24
    t.string   "cop_text"
    t.float    "cop_var",              limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coverages", ["authorization_id"], name: "index_coverages_on_authorization_id", using: :btree
  add_index "coverages", ["sub_coverage_type_id"], name: "index_coverages_on_sub_coverage_type_id", using: :btree

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
    t.string   "atc_code"
    t.string   "atc_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "detail_pharmacies", force: true do |t|
    t.integer  "benefit_id"
    t.integer  "detail_pharmacy_group_id"
    t.integer  "correlative"
    t.string   "type_code"
    t.string   "sunasa_code"
    t.string   "ean_code"
    t.string   "digemid_code"
    t.integer  "quantity"
    t.float    "unitary",                  limit: 24
    t.float    "initial_amount",           limit: 24
    t.float    "copayment",                limit: 24
    t.float    "amount",                   limit: 24
    t.float    "amount_not_covered",       limit: 24
    t.string   "exented_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "clinic_ruc"
    t.string   "clinic_code"
    t.string   "document_type_code"
    t.string   "document_number"
    t.string   "correlative_benefit"
    t.string   "diagnostic_code"
    t.string   "pharm_guide"
    t.date     "date"
    t.integer  "index"
    t.text     "observation"
  end

  add_index "detail_pharmacies", ["benefit_id"], name: "index_detail_pharmacies_on_benefit_id", using: :btree
  add_index "detail_pharmacies", ["detail_pharmacy_group_id"], name: "index_detail_pharmacies_on_detail_pharmacy_group_id", using: :btree

  create_table "detail_pharmacy_groups", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code"
    t.string   "name"
    t.date     "date"
    t.time     "time"
    t.integer  "quantity"
  end

  create_table "detail_service_groups", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.date     "date"
    t.time     "time"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "detail_services", force: true do |t|
    t.integer  "benefit_id"
    t.integer  "clasification_service_type_id"
    t.integer  "sector_id"
    t.integer  "detail_service_group_id"
    t.integer  "correlative"
    t.float    "quantity",                        limit: 24
    t.float    "unitary",                         limit: 24
    t.float    "copayment",                       limit: 24
    t.float    "amount",                          limit: 24
    t.float    "amount_not_covered",              limit: 24
    t.string   "diagnostic_code"
    t.string   "exented_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "clinic_ruc"
    t.string   "clinic_code"
    t.string   "payment_type_document"
    t.string   "payment_document"
    t.string   "service_code"
    t.text     "service_description"
    t.date     "date"
    t.string   "professional_type"
    t.string   "tuition_code"
    t.string   "clasification_service_type_code"
    t.string   "sector_code"
    t.integer  "correlative_benefit"
    t.integer  "index"
    t.string   "purchase_code"
    t.text     "observation"
  end

  add_index "detail_services", ["benefit_id"], name: "index_detail_services_on_benefit_id", using: :btree
  add_index "detail_services", ["clasification_service_type_id"], name: "index_detail_services_on_clasification_service_type_id", using: :btree
  add_index "detail_services", ["detail_service_group_id"], name: "index_detail_services_on_detail_service_group_id", using: :btree
  add_index "detail_services", ["sector_id"], name: "index_detail_services_on_sector_id", using: :btree

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

  create_table "diagnostics", force: true do |t|
    t.integer  "authorization_id"
    t.integer  "diagnostic_type_id"
    t.integer  "correlative"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "diagnostics", ["authorization_id"], name: "index_diagnostics_on_authorization_id", using: :btree
  add_index "diagnostics", ["diagnostic_type_id"], name: "index_diagnostics_on_diagnostic_type_id", using: :btree

  create_table "digemid_products", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "concentration"
    t.string   "form"
    t.string   "form_simplificated"
    t.string   "presentation"
    t.string   "fractions"
    t.date     "due_date_sanitary"
    t.string   "sanitary_number"
    t.string   "holder_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "doctors", force: true do |t|
    t.string   "tuition_code"
    t.integer  "document_identity_type_id"
    t.string   "document_identity_code"
    t.string   "card_number"
    t.string   "name"
    t.string   "paternal"
    t.string   "maternal"
    t.string   "to_clinic"
    t.string   "to_doctor"
    t.integer  "speciality_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "complet_name"
    t.string   "specialty_name"
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
    t.string   "password"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "factors", force: true do |t|
    t.integer  "insurance_id"
    t.integer  "clinic_area_id"
    t.float    "factor",         limit: 24
    t.float    "pharm",          limit: 24
    t.float    "bed",            limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "factors", ["clinic_area_id"], name: "index_factors_on_clinic_area_id", using: :btree
  add_index "factors", ["insurance_id"], name: "index_factors_on_insurance_id", using: :btree

  create_table "hospitalization_output_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hospitalization_types", force: true do |t|
    t.string   "code"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "indicator_globals", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "insurances", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "fact_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "consultation", limit: 24
    t.float    "pharm",        limit: 24
    t.float    "bed",          limit: 24
    t.string   "ruc"
  end

  create_table "insured_pharmacies", force: true do |t|
    t.integer  "authorization_id"
    t.integer  "doctor_id"
    t.integer  "employee_id"
    t.string   "ticket_code"
    t.float    "initial_amount",     limit: 24
    t.float    "copayment",          limit: 24
    t.float    "igv",                limit: 24
    t.float    "final_amount",       limit: 24
    t.boolean  "is_closed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_ticket"
    t.string   "liquidation"
    t.integer  "pharm_type_sale_id"
  end

  add_index "insured_pharmacies", ["pharm_type_sale_id"], name: "index_insured_pharmacies_on_pharm_type_sale_id", using: :btree

  create_table "insured_services", force: true do |t|
    t.integer  "authorization_id"
    t.integer  "doctor_id"
    t.integer  "clinic_area_id"
    t.integer  "employee_id"
    t.date     "date"
    t.time     "time"
    t.string   "ticket_code"
    t.float    "initial_amount",   limit: 24
    t.float    "copayment",        limit: 24
    t.float    "igv",              limit: 24
    t.float    "final_amount",     limit: 24
    t.boolean  "is_closed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "has_ticket"
    t.boolean  "is_consultation"
  end

  add_index "insured_services", ["authorization_id"], name: "index_insured_services_on_authorization_id", using: :btree
  add_index "insured_services", ["clinic_area_id"], name: "index_insured_services_on_clinic_area_id", using: :btree
  add_index "insured_services", ["doctor_id"], name: "index_insured_services_on_doctor_id", using: :btree
  add_index "insured_services", ["employee_id"], name: "index_insured_services_on_employee_id", using: :btree

  create_table "insureds", force: true do |t|
    t.integer  "afiliation_type_id"
    t.integer  "company_id"
    t.integer  "insurance_id"
    t.integer  "patient_id"
    t.string   "code"
    t.string   "hold_paternal"
    t.string   "hold_maternal"
    t.string   "hold_name"
    t.date     "validity_i"
    t.date     "validity_f"
    t.date     "inclusion_date"
    t.integer  "relation_ship_id"
    t.string   "card_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "company_name"
  end

  create_table "mechanism_payments", force: true do |t|
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
    t.string   "phone"
    t.string   "clinic_history_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "clinic_history"
    t.boolean  "is_insured"
  end

  add_index "patients", ["document_identity_type_id"], name: "index_patients_on_document_identity_type_id", using: :btree
  add_index "patients", ["employee_id"], name: "index_patients_on_employee_id", using: :btree

  create_table "pay_document_groups", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "quantity"
    t.date     "date"
    t.time     "time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "init_date"
    t.date     "end_date"
    t.string   "insurance_ruc"
  end

  create_table "pay_document_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pay_documents", force: true do |t|
    t.integer  "pay_document_type_id"
    t.integer  "pay_document_group_id"
    t.integer  "sub_mechanism_pay_type_id"
    t.integer  "indicator_global_id"
    t.integer  "authorization_id"
    t.string   "code"
    t.date     "emission_date"
    t.string   "product_code"
    t.float    "pre_agreed",                 limit: 24
    t.date     "date_pre_agreed"
    t.float    "amount_medicine_exonerated", limit: 24
    t.float    "total_cop_fijo",             limit: 24
    t.float    "total_cop_var",              limit: 24
    t.float    "net_amount",                 limit: 24
    t.float    "total_igv",                  limit: 24
    t.float    "total_amount",               limit: 24
    t.boolean  "has_notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "insurance_code"
    t.string   "insurance_ruc"
    t.string   "pay_document_type_code"
    t.integer  "quantity"
    t.string   "mechanism_code"
    t.string   "sub_mechanism_code"
    t.string   "money_code"
    t.string   "note_type_code"
    t.float    "note_amount",                limit: 24
    t.date     "note_date"
    t.string   "reason_code"
    t.date     "date_send"
    t.string   "indicator_global_code"
    t.string   "clinic_code"
    t.string   "clinic_ruc"
    t.date     "date"
    t.time     "time"
    t.string   "note_code"
    t.boolean  "is_closed"
    t.string   "social"
    t.string   "direction"
    t.boolean  "has_consultation"
    t.integer  "employee_id"
  end

  add_index "pay_documents", ["authorization_id"], name: "index_pay_documents_on_authorization_id", using: :btree
  add_index "pay_documents", ["employee_id"], name: "index_pay_documents_on_employee_id", using: :btree
  add_index "pay_documents", ["indicator_global_id"], name: "index_pay_documents_on_indicator_global_id", using: :btree
  add_index "pay_documents", ["pay_document_group_id"], name: "index_pay_documents_on_pay_document_group_id", using: :btree
  add_index "pay_documents", ["pay_document_type_id"], name: "index_pay_documents_on_pay_document_type_id", using: :btree
  add_index "pay_documents", ["sub_mechanism_pay_type_id"], name: "index_pay_documents_on_sub_mechanism_pay_type_id", using: :btree

  create_table "pharm_type_sales", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_pharm_exenteds", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_pharm_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "provider_types", force: true do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "providers", force: true do |t|
    t.integer  "provider_type_id"
    t.string   "name"
    t.integer  "doctor_id"
    t.string   "ruc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "providers", ["doctor_id"], name: "index_providers_on_doctor_id", using: :btree
  add_index "providers", ["provider_type_id"], name: "index_providers_on_provider_type_id", using: :btree

  create_table "purchase_coverage_services", force: true do |t|
    t.integer  "insured_service_id"
    t.integer  "service_id"
    t.float    "unitary",            limit: 24
    t.float    "copayment",          limit: 24
    t.float    "igv",                limit: 24
    t.float    "final_amount",       limit: 24
    t.boolean  "is_facturated"
    t.integer  "correlative"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_closed"
  end

  add_index "purchase_coverage_services", ["insured_service_id"], name: "index_purchase_coverage_services_on_insured_service_id", using: :btree
  add_index "purchase_coverage_services", ["service_id"], name: "index_purchase_coverage_services_on_service_id", using: :btree

  create_table "purchase_insured_pharmacies", force: true do |t|
    t.integer  "product_pharm_type_id"
    t.integer  "insured_pharmacy_id"
    t.integer  "cum_sunasa_product_id"
    t.integer  "digemid_product_id"
    t.integer  "ean_product_id"
    t.integer  "product_pharm_exented_id"
    t.string   "name"
    t.integer  "quantity"
    t.float    "unitary",                  limit: 24
    t.float    "initial_amount",           limit: 24
    t.float    "copayment",                limit: 24
    t.float    "igv",                      limit: 24
    t.float    "final_amount",             limit: 24
    t.boolean  "is_facturated"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "purchase_insured_pharmacies", ["cum_sunasa_product_id"], name: "index_purchase_insured_pharmacies_on_cum_sunasa_product_id", using: :btree
  add_index "purchase_insured_pharmacies", ["digemid_product_id"], name: "index_purchase_insured_pharmacies_on_digemid_product_id", using: :btree
  add_index "purchase_insured_pharmacies", ["ean_product_id"], name: "index_purchase_insured_pharmacies_on_ean_product_id", using: :btree
  add_index "purchase_insured_pharmacies", ["insured_pharmacy_id"], name: "index_purchase_insured_pharmacies_on_insured_pharmacy_id", using: :btree
  add_index "purchase_insured_pharmacies", ["product_pharm_exented_id"], name: "index_purchase_insured_pharmacies_on_product_pharm_exented_id", using: :btree
  add_index "purchase_insured_pharmacies", ["product_pharm_type_id"], name: "index_purchase_insured_pharmacies_on_product_pharm_type_id", using: :btree

  create_table "purchase_insured_services", force: true do |t|
    t.integer  "insured_service_id"
    t.integer  "service_id"
    t.integer  "service_exented_id"
    t.integer  "diagnostic_id"
    t.integer  "quantity"
    t.float    "initial_amount",     limit: 24
    t.float    "copayment",          limit: 24
    t.float    "igv",                limit: 24
    t.float    "final_amount",       limit: 24
    t.integer  "correlative"
    t.boolean  "is_printed"
    t.boolean  "is_facturated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "unitary",            limit: 24
    t.boolean  "has_discount"
  end

  add_index "purchase_insured_services", ["diagnostic_id"], name: "index_purchase_insured_services_on_diagnostic_id", using: :btree
  add_index "purchase_insured_services", ["insured_service_id"], name: "index_purchase_insured_services_on_insured_service_id", using: :btree
  add_index "purchase_insured_services", ["service_exented_id"], name: "index_purchase_insured_services_on_service_exented_id", using: :btree
  add_index "purchase_insured_services", ["service_id"], name: "index_purchase_insured_services_on_service_id", using: :btree

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
    t.integer  "sub_category_service_id"
    t.string   "code"
    t.string   "name"
    t.string   "contable_code"
    t.string   "contable_name"
    t.integer  "clinic_area_id"
    t.float    "unitary",                 limit: 24
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

  create_table "sub_category_services", force: true do |t|
    t.integer  "category_service_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_coverage_types", force: true do |t|
    t.integer  "coverage_type_id"
    t.string   "fact_code"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "other_code"
  end

  add_index "sub_coverage_types", ["coverage_type_id"], name: "index_sub_coverage_types_on_coverage_type_id", using: :btree

  create_table "sub_mechanism_pay_types", force: true do |t|
    t.integer  "mechanism_payment_id"
    t.string   "code"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tedef_areas", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
