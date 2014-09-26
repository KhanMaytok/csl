class AddFirstDocumentTypeCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :first_document_type_code, :string
  end
end
