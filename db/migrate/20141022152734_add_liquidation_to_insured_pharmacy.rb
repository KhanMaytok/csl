class AddLiquidationToInsuredPharmacy < ActiveRecord::Migration
  def change
    add_column :insured_pharmacies, :liquidation, :string
  end
end
