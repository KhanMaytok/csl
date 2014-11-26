class CreateDetailPharmacies < ActiveRecord::Migration
  def change
    create_table :detail_pharmacies do |t|
      t.references :benefit, index: true
      t.references :detail_pharmacy_group, index: true
      t.integer :correlative
      t.string :type_code
      t.string :sunasa_code
      t.string :ean_code
      t.string :digemid_code
      t.integer :quantity
      t.float :unitary
      t.float :initial_amount
      t.float :copayment
      t.float :amount
      t.float :amount_not_covered
      t.string :exented_code

      t.timestamps
    end
  end
end
