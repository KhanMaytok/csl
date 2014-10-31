class AddPurchaseCodeToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :purchase_code, :string
  end
end
