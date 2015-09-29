class AddNotExportToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :not_export, :boolean
  end
end
