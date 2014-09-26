class AddDateSendToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :date_send, :date
  end
end
