class AddQuantityToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :quantity, :integer
  end
end
