class CreatePurchaseInsuredServices < ActiveRecord::Migration
  def change
    create_table :purchase_insured_services do |t|
      t.references :insured_service, index: true
      t.references :service, index: true
      t.integer :quantity
      t.float :unitary_var
      t.float :initial_amount
      t.float :cop_fijo
      t.float :cop_var
      t.float :igv
      t.float :final_amount
      t.boolean :is_facturated
      t.boolean :is_unitary_var

      t.timestamps
    end
  end
end
