class AddClinicCodeToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :clinic_code, :string
  end
end
