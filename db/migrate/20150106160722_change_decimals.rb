class ChangeDecimals < ActiveRecord::Migration
  def change  	
  	change_column :purchase_insured_pharmacies, :unitary, :decimal, precision: 10, scale: 5
  	change_column :purchase_insured_pharmacies, :initial_amount, :decimal, precision: 10, scale: 5
  	change_column :purchase_insured_pharmacies, :igv, :decimal, precision: 10, scale: 5
  	change_column :purchase_insured_pharmacies, :copayment, :decimal, precision: 10, scale: 5
  	change_column :purchase_insured_pharmacies, :final_amount, :decimal, precision: 10, scale: 5
  	change_column :purchase_insured_pharmacies, :without_igv, :decimal, precision: 10, scale: 5
  	change_column :purchase_insured_pharmacies, :first_copayment, :decimal, precision: 10, scale: 5

  	change_column :insured_pharmacies, :initial_amount, :decimal, precision: 10, scale: 5
  	change_column :insured_pharmacies, :igv, :decimal, precision: 10, scale: 5
  	change_column :insured_pharmacies, :copayment, :decimal, precision: 10, scale: 5
  	change_column :insured_pharmacies, :final_amount, :decimal, precision: 10, scale: 5
  	change_column :insured_pharmacies, :without_igv, :decimal, precision: 10, scale: 5
  	change_column :insured_pharmacies, :first_copayment, :decimal, precision: 10, scale: 5

  	change_column :detail_pharmacies, :unitary, :decimal, precision: 10, scale: 5
  	change_column :detail_pharmacies, :initial_amount, :decimal, precision: 10, scale: 5
  	change_column :detail_pharmacies, :copayment, :decimal, precision: 10, scale: 5
  	change_column :detail_pharmacies, :amount, :decimal, precision: 10, scale: 5
  	change_column :detail_pharmacies, :amount_not_covered, :decimal, precision: 10, scale: 5

  	change_column :benefits, :expense_fee, :decimal, precision: 10, scale: 5
  	change_column :benefits, :expense_dental, :decimal, precision: 10, scale: 5
  	change_column :benefits, :expense_hotelery, :decimal, precision: 10, scale: 5
  	change_column :benefits, :expense_aux_lab, :decimal, precision: 10, scale: 5
  	change_column :benefits, :expense_aux_img, :decimal, precision: 10, scale: 5
  	change_column :benefits, :expense_pharmacy, :decimal, precision: 10, scale: 5
  	change_column :benefits, :expense_prosthesis, :decimal, precision: 10, scale: 5
  	change_column :benefits, :expense_medicaments_exonerated, :decimal, precision: 10, scale: 5
  	change_column :benefits, :cop_fijo, :decimal, precision: 10, scale: 5
  	change_column :benefits, :cop_var, :decimal, precision: 10, scale: 5
  	change_column :benefits, :total_expense, :decimal, precision: 10, scale: 5
  	change_column :benefits, :expense_other, :decimal, precision: 10, scale: 5

  	change_column :pay_documents, :pre_agreed, :decimal, precision: 10, scale: 5
  	change_column :pay_documents, :amount_medicine_exonerated, :decimal, precision: 10, scale: 5
  	change_column :pay_documents, :total_cop_fijo, :decimal, precision: 10, scale: 5
  	change_column :pay_documents, :total_cop_var, :decimal, precision: 10, scale: 5
  	change_column :pay_documents, :net_amount, :decimal, precision: 10, scale: 5
  	change_column :pay_documents, :total_igv, :decimal, precision: 10, scale: 5
  	change_column :pay_documents, :total_amount, :decimal, precision: 10, scale: 5
  	change_column :pay_documents, :note_amount, :decimal, precision: 10, scale: 5
  end
end
