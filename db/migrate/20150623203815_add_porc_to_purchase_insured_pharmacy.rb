class AddPorcToPurchaseInsuredPharmacy < ActiveRecord::Migration
  def change
    add_column :purchase_insured_pharmacies, :porc, :float
  end
end
