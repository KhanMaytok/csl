class RemovePorcFromPurchaseInsuredPharmacy < ActiveRecord::Migration
  def change
    remove_column :purchase_insured_pharmacies, :porc, :float
  end
end
