class AddDateToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :date, :date
  end
end
