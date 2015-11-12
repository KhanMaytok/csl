class AddShowToInsurance < ActiveRecord::Migration
  def change
    add_column :insurances, :show, :boolean
  end
end
