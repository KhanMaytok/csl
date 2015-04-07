class AddInsuranceCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :insurance_code, :string
  end
end
