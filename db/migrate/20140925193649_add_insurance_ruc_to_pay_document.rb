class AddInsuranceRucToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :insurance_ruc, :string
  end
end
