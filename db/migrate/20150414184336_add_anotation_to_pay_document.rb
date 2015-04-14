class AddAnotationToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :anotation, :string
  end
end
