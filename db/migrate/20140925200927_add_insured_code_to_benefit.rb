class AddInsuredCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :insured_code, :string
  end
end
