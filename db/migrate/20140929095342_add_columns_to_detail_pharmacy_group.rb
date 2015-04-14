class AddColumnsToDetailPharmacyGroup < ActiveRecord::Migration
  def change
    add_column :detail_pharmacy_groups, :code, :string
    add_column :detail_pharmacy_groups, :name, :string
    add_column :detail_pharmacy_groups, :date, :date
    add_column :detail_pharmacy_groups, :time, :time
    add_column :detail_pharmacy_groups, :quantity, :integer
  end
end
