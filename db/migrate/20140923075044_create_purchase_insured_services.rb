class CreatePurchaseInsuredServices < ActiveRecord::Migration
  def change
    create_table :purchase_insured_services do |t|
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

      t.timestamps
    end
  end
end
