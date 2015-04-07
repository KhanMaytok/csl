class AddServiceDescriptionToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :service_description, :text
  end
end
