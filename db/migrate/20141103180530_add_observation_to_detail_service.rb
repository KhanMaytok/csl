class AddObservationToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :observation, :text
  end
end
