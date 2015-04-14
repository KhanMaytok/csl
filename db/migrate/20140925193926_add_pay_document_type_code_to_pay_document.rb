class AddPayDocumentTypeCodeToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :pay_document_type_code, :string
  end
end
