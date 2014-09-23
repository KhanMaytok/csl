class CreatePurchaseInsuredPharmacies < ActiveRecord::Migration
  def change
    create_table :purchase_insured_pharmacies do |t|
      t.references :product_pharm_type, index: true
      t.references :insured_pharmacy, index: true
      t.references :cum_sunasa_product, index: true
      t.references :digemid_product, index: true
      t.references :ean_product, index: true
      t.references :product_pharm_exented, index: true
      t.string :name
      t.integer :quantity
      t.float :unitary
      t.float :initial_amount
      t.float :copayment
      t.float :igv
      t.float :final_amount
      t.boolean :is_facturated

      t.timestamps
    end
  end
end
