class CreateParticularServices < ActiveRecord::Migration
  def change
    create_table :particular_services do |t|
      t.references :authorization, index: true
      t.references :doctor, index: true
      t.references :clinic_area, index: true
      t.references :employee, index: true
      t.date :date
      t.time :time
      t.string :ticket_code
      t.float :initial_amount
      t.float :igv
      t.float :final_amount
      t.boolean :is_closed
      t.boolean :has_ticket
      t.boolean :is_consultation

      t.timestamps
    end
  end
end
