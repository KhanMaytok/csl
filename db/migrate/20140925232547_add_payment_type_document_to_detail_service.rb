class AddPaymentTypeDocumentToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :payment_type_document, :string
  end
end
