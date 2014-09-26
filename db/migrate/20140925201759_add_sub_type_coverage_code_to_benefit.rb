class AddSubTypeCoverageCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :sub_type_coverage_code, :string
  end
end
