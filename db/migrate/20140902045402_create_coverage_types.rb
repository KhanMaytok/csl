class CreateCoverageTypes < ActiveRecord::Migration
  def change
    create_table :coverage_types do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
