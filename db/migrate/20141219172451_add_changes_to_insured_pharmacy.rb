class AddChangesToInsuredPharmacy < ActiveRecord::Migration
  def change
    add_column :insured_pharmacies, :without_igv, :float
    add_column :insured_pharmacies, :first_copayment, :float
  end
end
