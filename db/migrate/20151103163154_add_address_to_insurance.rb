class AddAddressToInsurance < ActiveRecord::Migration
  def change
    add_column :insurances, :address, :string
  end
end
