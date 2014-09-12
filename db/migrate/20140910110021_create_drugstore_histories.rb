class CreateDrugstoreHistories < ActiveRecord::Migration
  def change
    create_table :drugstore_histories do |t|
      t.integer :drugstore_product_id
      t.date :date
      t.float :price

      t.timestamps
    end
  end
end
