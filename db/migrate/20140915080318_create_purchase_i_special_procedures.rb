class CreatePurchaseISpecialProcedures < ActiveRecord::Migration
  def change
    create_table :purchase_i_special_procedures do |t|
      t.integer :i_special_procedure_id
      t.integer :service_id
      t.integer :quantity
      t.float :amount
      t.float :cop_var
      t.float :cop_fijo
      t.integer :correlative
      t.integer :diagnostic_id

      t.timestamps
    end
  end
end
