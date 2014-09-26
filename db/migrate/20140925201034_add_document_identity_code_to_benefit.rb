class AddDocumentIdentityCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :document_identity_code, :string
  end
end
