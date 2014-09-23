class CreateInsuredServices < ActiveRecord::Migration
  def change
    create_table :insured_services do |t|
      t.integer :authorization_id
      t.integer :doctor_id
      t.integer :clinic_area_id
      t.integer :employee_id
      t.string :ticket_code
      t.float :initial_amount
      t.float :copayment
      t.float :igv
      t.float :final_amount
      t.boolean :is_closed

      t.timestamps
    end
  end
end
