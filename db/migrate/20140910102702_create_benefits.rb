class CreateBenefits < ActiveRecord::Migration
  def change
    create_table :benefits do |t|
      t.integer :pay_document_id
      t.integer :correlative
      t.integer :document_type_id
      t.string :second_document_code
      t.integer :sub_coverage_fact_type_id
      t.date :date
      t.time :time
      t.float :expense_fee
      t.float :expense_dental
      t.float :expense_hotelery
      t.float :expense_aux_lab
      t.float :expense_aux_img
      t.float :expense_pharmacy
      t.float :expense_prosthesis
      t.float :expense_medicaments_exonerated
      t.float :cop_fijo
      t.string :cop_var
      t.string :float
      t.float :total_expense

      t.timestamps
    end
  end
end
