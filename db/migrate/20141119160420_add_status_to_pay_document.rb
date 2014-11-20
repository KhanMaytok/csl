class AddStatusToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :status, :string
  end
end
