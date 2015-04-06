class AddCreditNoteToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :credit_note, :string
  end
end
