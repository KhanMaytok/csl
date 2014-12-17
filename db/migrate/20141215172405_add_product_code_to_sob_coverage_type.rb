class AddProductCodeToSobCoverageType < ActiveRecord::Migration
  def change
    add_column :sub_coverage_types, :product_code, :string
  end
end
