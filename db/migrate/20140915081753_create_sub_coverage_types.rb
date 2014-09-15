class CreateSubCoverageTypes < ActiveRecord::Migration
  def change
    create_table :sub_coverage_types do |t|
      t.integer :coverage_type_id
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
