class AddPharmToInsurance < ActiveRecord::Migration
  def change
    add_column :insurances, :pharm, :float
  end
end
