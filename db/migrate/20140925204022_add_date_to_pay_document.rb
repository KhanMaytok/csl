class AddDateToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :date, :date
  end
end
