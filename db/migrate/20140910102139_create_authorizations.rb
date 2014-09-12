class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.integer :patient_id
      t.integer :money_id
      t.integer :clinic_id
      t.string :code
      t.datetime :date
      t.integer :status_id
      t.integer :doctor_id
      t.boolean :has_record
      t.integer :consultations_quantity
      t.text :symptoms

      t.timestamps
    end
  end
end
