class AddValToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :val, :boolean
  end
end
