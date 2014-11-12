class AddMyTimeToPayDocumentGroup < ActiveRecord::Migration
  def change
    add_column :pay_document_groups, :init_date, :date
    add_column :pay_document_groups, :end_date, :date
    add_column :pay_document_groups, :insurance_ruc, :string
  end
end
