class AddTimeCreateToInsuredPharmacy < ActiveRecord::Migration
  def change
    add_column :insured_pharmacies, :time_create, :datetime
  end
end
