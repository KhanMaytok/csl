class AddInsuranceRucToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :insurance_ruc, :string
  end
end
