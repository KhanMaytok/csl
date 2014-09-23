class CreatePurchaseInsuredPharmacies < ActiveRecord::Migration
  def change
    create_table :purchase_insured_pharmacies do |t|
      t.references :product_pharm_type, index: true
      t.references :insured_pharmacy, index: true
      t.references :cum_sunasa_product, index: true
      t.references :digemid_product, index: true
      t.references :ean_product, index: true
      t.integer :correlative
      t.integer :quantity
      t.float :unitary
      t.float :inital_amount
      t.float :cop_var
      t.float :igv
      t.float :final_amount
      t.boolean :is_facturated
      t.boolean :is_igv_exented

      t.timestamps
    end
  end
end
