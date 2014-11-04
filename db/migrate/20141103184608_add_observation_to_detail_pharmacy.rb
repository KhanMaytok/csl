class AddObservationToDetailPharmacy < ActiveRecord::Migration
  def change
    add_column :detail_pharmacies, :observation, :text
  end
end
