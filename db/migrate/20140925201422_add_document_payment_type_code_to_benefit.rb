class AddDocumentPaymentTypeCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :document_payment_type_code, :string
  end
end
