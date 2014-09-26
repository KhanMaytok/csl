class AddClinicRucToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :clinic_ruc, :string
  end
end
