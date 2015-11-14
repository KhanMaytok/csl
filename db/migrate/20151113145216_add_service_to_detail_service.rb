class AddServiceToDetailService < ActiveRecord::Migration
  def change
    add_reference :detail_services, :service, index: true
    add_column :detail_services, :manual, :boolean
  end
end
