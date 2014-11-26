class AddClinicCodeToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :clinic_code, :string
  end
end
