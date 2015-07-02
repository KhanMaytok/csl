class AddOtherToPurchaseInsuredPharmacy < ActiveRecord::Migration
  def change
    add_column :purchase_insured_pharmacies, :other, :string
  end
end
