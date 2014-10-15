class AddHasConsultationToPayDocuments < ActiveRecord::Migration
  def change
    add_column :pay_documents, :has_consultation, :boolean
  end
end
