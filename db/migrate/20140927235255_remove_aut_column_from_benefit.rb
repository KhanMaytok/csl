class RemoveAutColumnFromBenefit < ActiveRecord::Migration
  def change
    remove_column :benefits, :document_type_code, :string
    remove_column :benefits, :first_document_type_code, :string
    remove_column :benefits, :document_payment_code, :string
    remove_column :benefits, :document_payment_type_code, :string
  end
end
