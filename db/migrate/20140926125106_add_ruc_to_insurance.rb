class AddRucToInsurance < ActiveRecord::Migration
  def change
    add_column :insurances, :ruc, :string
  end
end
