class RemoveTypePurchaseFromDetailService < ActiveRecord::Migration
  def change
    remove_column :detail_services, :type_purchase, :string
  end
end
