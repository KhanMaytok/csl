class AddChangesToPurchaseInsuredPharmacy < ActiveRecord::Migration
  def change
    add_column :purchase_insured_pharmacies, :without_igv, :float
    add_column :purchase_insured_pharmacies, :first_copayment, :float
  end
end
