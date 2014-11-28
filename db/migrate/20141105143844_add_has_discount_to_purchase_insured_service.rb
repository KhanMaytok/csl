class AddHasDiscountToPurchaseInsuredService < ActiveRecord::Migration
  def change
    add_column :purchase_insured_services, :has_discount, :boolean
  end
end
