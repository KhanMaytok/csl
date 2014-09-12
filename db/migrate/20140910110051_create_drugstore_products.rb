class CreateDrugstoreProducts < ActiveRecord::Migration
  def change
    create_table :drugstore_products do |t|
      t.string :code
      t.string :name
      t.float :actual_price

      t.timestamps
    end
  end
end
