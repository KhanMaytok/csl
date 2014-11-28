class AddIndexToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :index, :integer
  end
end
