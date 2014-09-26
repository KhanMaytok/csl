class AddDocumentIdentityTypeCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :document_identity_type_code, :string
  end
end
