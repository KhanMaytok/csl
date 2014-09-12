class CreateExclusions < ActiveRecord::Migration
  def change
    create_table :exclusions do |t|
      t.integer :authorization_id
      t.integer :diagnostic_id
      t.text :observation

      t.timestamps
    end
  end
end
