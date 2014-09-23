class CreateInsuredServices < ActiveRecord::Migration
  def change
    create_table :insured_services do |t|
      t.references :authorization, index: true
      t.references :doctor, index: true
      t.references :clinica_area, index: true
      t.references :employee, index: true
      t.date :date
      t.time :time
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
