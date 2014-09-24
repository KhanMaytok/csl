class CreateBenefits < ActiveRecord::Migration
  def change
    create_table :benefits do |t|
      t.references :pay_document, index: true
      t.references :document_type, index: true
      t.string :document_type_code
      t.references :benefit_group, index: true
      t.integer :correlative
      t.string :cod_benefit_intern
      t.date :date
      t.time :time
      t.string :ruc_extern_entity
      t.date :transference_date
      t.time :transference_time
      t.string :hospitalization_type_code
      t.string :hospitalization_output_type_code
      t.date :admission_date
      t.date :discharge_date
      t.string :days_hospitalization
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
