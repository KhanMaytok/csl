class CreateISpecialProcedures < ActiveRecord::Migration
  def change
    create_table :i_special_procedures do |t|
      t.integer :authorization_id
      t.integer :doctor_id
      t.date :date
      t.time :time
      t.string :ticket_code

      t.timestamps
    end
  end
end
