class AddClasificationServiceTypeToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :clasification_service_type, :string
  end
end
