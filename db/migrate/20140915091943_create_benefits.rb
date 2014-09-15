class CreateBenefits < ActiveRecord::Migration
  def change
    create_table :benefits do |t|
      t.integer :pay_document_id
      t.string :code_benefit_intern
      t.integer :correlative
      t.integer :document_type_id
      t.string :second_document_code
      t.integer :sub_coverage_type_id
      t.date :date
      t.time :time
      t.string :ruc_extern_entity
      t.date :transference_date
      t.time :transference_time
      t.integer :hospitalization_type_id
      t.date :admission_date
      t.date :discharge_date
      t.integer :discharge_type_id
      t.integer :number_days_hospitalization
      t.float :expense_fee
      t.float :expense_dental
      t.float :expense_hotelery
      t.float :expense_aux_lab
      t.float :expense_aux_img
      t.float :expense_pharmacy
      t.float :expense_prosthesis
      t.float :expense_medicaments_exonerated
      t.float :cop_fijo
      t.float :cop_var
      t.float :total_expense

      t.timestamps
    end
  end
end
