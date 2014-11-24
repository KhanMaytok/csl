class AddMoneyCodeToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :money_code, :string
  end
end
