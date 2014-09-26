class AddNoteTypeCodeToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :note_type_code, :string
  end
end
