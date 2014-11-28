class AddClasificationServiceTypeCodeToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :clasification_service_type_code, :string
  end
end
