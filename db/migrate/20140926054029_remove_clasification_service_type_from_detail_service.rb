class RemoveClasificationServiceTypeFromDetailService < ActiveRecord::Migration
  def change
    remove_column :detail_services, :clasification_service_type, :string
  end
end
