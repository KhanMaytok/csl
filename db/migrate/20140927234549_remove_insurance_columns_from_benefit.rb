class RemoveInsuranceColumnsFromBenefit < ActiveRecord::Migration
  def change
    remove_column :benefits, :insurance_ruc, :string
    remove_column :benefits, :insurance_code, :string
  end
end
