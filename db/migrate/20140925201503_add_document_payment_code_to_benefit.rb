class AddDocumentPaymentCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :document_payment_code, :string
  end
end
