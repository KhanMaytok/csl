class AddNoteDateToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :note_date, :date
  end
end
