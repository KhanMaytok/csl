class AddNoteCodeToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :note_code, :string
  end
end
