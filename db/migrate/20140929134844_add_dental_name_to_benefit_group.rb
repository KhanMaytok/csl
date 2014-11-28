class AddDentalNameToBenefitGroup < ActiveRecord::Migration
  def change
    add_column :benefit_groups, :dental_name, :string
  end
end
