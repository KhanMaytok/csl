class AddIsClosedToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :is_closed, :boolean
  end
end
