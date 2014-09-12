class CreateRadiographs < ActiveRecord::Migration
  def change
    create_table :radiographs do |t|
      t.integer :authorization_id
      t.boolean :is_insured
      t.float :amount

      t.timestamps
    end
  end
end
