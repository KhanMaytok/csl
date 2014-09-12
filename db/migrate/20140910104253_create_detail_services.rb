class CreateDetailServices < ActiveRecord::Migration
  def change
    create_table :detail_services do |t|
      t.integer :benefit_id
      t.integer :correlative
      t.integer :clasification_service_type_id
      t.integer :nomenclator_service_id
      t.date :date
      t.integer :quantity
      t.float :unit_amount
      t.float :copayment
      t.float :amount
      t.float :amount_not_covered
      t.string :diagnostic_code
      t.integer :service_exented_id
      t.integer :sector_id

      t.timestamps
    end
  end
end
