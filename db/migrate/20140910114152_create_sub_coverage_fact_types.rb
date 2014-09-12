class CreateSubCoverageFactTypes < ActiveRecord::Migration
  def change
    create_table :sub_coverage_fact_types do |t|
      t.integer :coverage_fact_type_id
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
