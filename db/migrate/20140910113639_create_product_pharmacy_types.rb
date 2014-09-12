class CreateProductPharmacyTypes < ActiveRecord::Migration
  def change
    create_table :product_pharmacy_types do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
