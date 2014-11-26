class AddColumnsToDetailPharmacy < ActiveRecord::Migration
  def change
    add_column :detail_pharmacies, :clinic_ruc, :string
    add_column :detail_pharmacies, :clinic_code, :string
    add_column :detail_pharmacies, :document_type_code, :string
    add_column :detail_pharmacies, :document_number, :string
    add_column :detail_pharmacies, :correlative_benefit, :string
    add_column :detail_pharmacies, :diagnostic_code, :string
    add_column :detail_pharmacies, :pharm_guide, :string
  end
end
