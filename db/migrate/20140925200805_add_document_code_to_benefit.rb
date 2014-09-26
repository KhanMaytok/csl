class AddDocumentCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :document_code, :string
  end
end
