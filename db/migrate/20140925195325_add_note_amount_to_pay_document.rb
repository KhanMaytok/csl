class AddNoteAmountToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :note_amount, :float
  end
end
