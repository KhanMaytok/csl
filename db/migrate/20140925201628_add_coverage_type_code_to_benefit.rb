class AddCoverageTypeCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :coverage_type_code, :string
  end
end
