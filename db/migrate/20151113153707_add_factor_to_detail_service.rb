class AddFactorToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :factor, :float
  end
end
