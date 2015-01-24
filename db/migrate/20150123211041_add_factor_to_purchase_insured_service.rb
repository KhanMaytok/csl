class AddFactorToPurchaseInsuredService < ActiveRecord::Migration
  def change
    add_column :purchase_insured_services, :factor, :float
  end
end
