class CreateDetailServices < ActiveRecord::Migration
  def change
    create_table :detail_services do |t|
      t.integer :benefit_id
      t.integer :correlative
      t.integer :clasification_service_type_id
      t.integer :quantity
      t.float :copayment
      t.float :unitary
      t.float :amount
      t.float :amount_not_covered
      t.integer :service_exented_id
      t.integer :sector_id

      t.timestamps
    end
  end
end
