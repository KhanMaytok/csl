class AddWithoutPorcToPurchaseInsuredPharmacy < ActiveRecord::Migration
  def change
    add_column :purchase_insured_pharmacies, :without_porc, :boolean
  end
end
