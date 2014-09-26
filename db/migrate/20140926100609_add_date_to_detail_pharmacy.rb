class AddDateToDetailPharmacy < ActiveRecord::Migration
  def change
    add_column :detail_pharmacies, :date, :date
  end
end
