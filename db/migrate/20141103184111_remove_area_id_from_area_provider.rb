class RemoveAreaIdFromAreaProvider < ActiveRecord::Migration
  def change
    remove_column :area_providers, :area_id, :integer
  end
end
