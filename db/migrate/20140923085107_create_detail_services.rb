class CreateDetailServices < ActiveRecord::Migration
  def change
    create_table :detail_services do |t|
      t.references :benefit, index: true
      t.references :clasification_service_type, index: true
      t.references :sector, index: true
      t.references :detail_service_group, index: true
      t.integer :correlative
      t.float :quantity
      t.float :unitary
      t.float :initial_amount
      t.float :copayment
      t.float :amount
      t.float :amount_not_covered
      t.string :diagnostic_code
      t.string :exented_code

      t.timestamps
    end
  end
end
