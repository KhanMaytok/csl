class AddTimeToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :time, :time
  end
end
