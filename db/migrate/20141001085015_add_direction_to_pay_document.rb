class AddDirectionToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :direction, :string
  end
end
