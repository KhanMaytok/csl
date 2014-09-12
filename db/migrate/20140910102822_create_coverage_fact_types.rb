class CreateCoverageFactTypes < ActiveRecord::Migration
  def change
    create_table :coverage_fact_types do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
