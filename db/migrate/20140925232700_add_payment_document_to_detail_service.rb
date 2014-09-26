class AddPaymentDocumentToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :payment_document, :string
  end
end
