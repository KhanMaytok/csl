class AddBedToInsurance < ActiveRecord::Migration
  def change
    add_column :insurances, :bed, :float
  end
end
