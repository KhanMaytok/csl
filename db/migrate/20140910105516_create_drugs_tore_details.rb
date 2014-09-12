class CreateDrugsToreDetails < ActiveRecord::Migration
  def change
    create_table :drugs_tore_details do |t|
      t.integer :drugstore_attention_id
      t.integer :drugstore_product_id
      t.integer :quantity
      t.integer :amount

      t.timestamps
    end
  end
end
