class CreateCoverages < ActiveRecord::Migration
  def change
    create_table :coverages do |t|
      t.integer :authorization_id
      t.string :code
      t.string :name
      t.float :cop_fijo
      t.float :cop_var

      t.timestamps
    end
  end
end
