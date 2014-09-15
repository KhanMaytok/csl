class CreatePurchaseIPharmacies < ActiveRecord::Migration
  def change
    create_table :purchase_i_pharmacies do |t|
      t.integer :product_pharm_type_id
      t.integer :i_pharmacy_id
      t.integer :cum_sunasa_product_id
      t.integer :digemid_product_id
      t.integer :ean_product_id
      t.integer :quantity
      t.float :unitary
      t.float :cop_quantity
      t.float :amount

      t.timestamps
    end
  end
end
