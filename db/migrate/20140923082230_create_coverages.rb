class CreateCoverages < ActiveRecord::Migration
  def change
    create_table :coverages do |t|
      t.references :authorization, index: true
      t.references :sub_coverage_type, index: true
      t.string :code
      t.string :name
      t.float :cop_fijo
      t.string :cop_text
      t.float :cop_var

      t.timestamps
    end
  end
end
