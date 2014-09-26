class AddInsuranceCodeToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :insurance_code, :string
  end
end
