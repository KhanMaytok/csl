class AddClinicRucToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :clinic_ruc, :string
  end
end
