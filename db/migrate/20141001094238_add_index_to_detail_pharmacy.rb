class AddIndexToDetailPharmacy < ActiveRecord::Migration
  def change
    add_column :detail_pharmacies, :index, :integer
  end
end
