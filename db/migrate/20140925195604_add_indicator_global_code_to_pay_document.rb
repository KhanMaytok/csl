class AddIndicatorGlobalCodeToPayDocument < ActiveRecord::Migration
  def change
  	add_column :pay_documents, :indicator_global_code, :string
  end
end
