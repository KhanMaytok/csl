class CreateDetailPharmacies < ActiveRecord::Migration
  def change
    create_table :detail_pharmacies do |t|
      t.integer :benefit_id
      t.integer :correlative
      t.integer :product_pharmacy_type_id
      t.integer :cum_sunasa_product_id
      t.integer :medical_input_id
      t.integer :digemid_product_id
      t.integer :ean_product_id
      t.date :dispensation_date
      t.integer :quantity
      t.float :unit_amount
      t.float :copayment
      t.float :amount
      t.float :amount_not_covered
      t.string :diagnostic_code
      t.integer :product_pharm_exented_id
      t.integer :guide_pharmacy

      t.timestamps
    end
  end
end
