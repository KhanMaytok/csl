class CreateDetailPharmacyGroups < ActiveRecord::Migration
  def change
    create_table :detail_pharmacy_groups do |t|

      t.timestamps
    end
  end
end
