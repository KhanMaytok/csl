class AddTypePurchaseToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :type_purchase, :string
  end
end
