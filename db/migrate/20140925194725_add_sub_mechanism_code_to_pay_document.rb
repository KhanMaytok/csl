class AddSubMechanismCodeToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :sub_mechanism_code, :string
  end
end
