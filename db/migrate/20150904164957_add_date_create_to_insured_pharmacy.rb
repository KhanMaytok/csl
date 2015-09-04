class AddDateCreateToInsuredPharmacy < ActiveRecord::Migration
  def change
    add_column :insured_pharmacies, :date_create, :date
  end
end
