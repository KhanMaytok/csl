class AddOtherCodeToSubCoverageType < ActiveRecord::Migration
  def change
    add_column :sub_coverage_types, :other_code, :string
  end
end
