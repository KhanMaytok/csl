class AddUnitaryToPurchaseInsuredService < ActiveRecord::Migration
  def change
    add_column :purchase_insured_services, :unitary, :float
  end
end
