class CreateSubCoverageTypes < ActiveRecord::Migration
  def change
    create_table :sub_coverage_types do |t|
      t.references :coverage_type, index: true
      t.string :fact_code
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
