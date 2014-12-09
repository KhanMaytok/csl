class CreatePurchaseParticularServices < ActiveRecord::Migration
  def change
    create_table :purchase_particular_services do |t|
      t.references :insured_service, index: true
      t.references :service, index: true
      t.references :service_exented, index: true
      t.references :diagnostic, index: true
      t.integer :quantity
      t.float :initial_amount
      t.float :copayment
      t.float :igv
      t.float :final_amount
      t.integer :correlative
      t.boolean :is_printed
      t.boolean :is_facturated
      t.float :unitary
      t.boolean :has_discount
      t.string :observation

      t.timestamps
    end
  end
end
