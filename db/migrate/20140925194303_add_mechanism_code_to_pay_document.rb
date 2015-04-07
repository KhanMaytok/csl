class AddMechanismCodeToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :mechanism_code, :string
  end
end
