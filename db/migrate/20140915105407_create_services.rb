class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.integer :sub_category_service_id
      t.string :code
      t.string :name
      t.string :contable_code
      t.string :contable_name
      t.float :price

      t.timestamps
    end
  end
end
