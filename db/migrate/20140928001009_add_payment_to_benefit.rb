class AddPaymentToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :document_payment_type, :string
  end
end
