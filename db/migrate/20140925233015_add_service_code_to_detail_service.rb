class AddServiceCodeToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :service_code, :string
  end
end
