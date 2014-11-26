class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.references :patient, index: true
      t.references :money, index: true
      t.references :clinic, index: true
      t.references :status, index: true
      t.references :doctor, index: true
      t.references :product, index: true
      t.string :code
      t.datetime :date
      t.boolean :has_record
      t.integer :consultations_quantity
      t.text :symptoms
      t.string :ruc_transference
      t.date :date_transference
      t.time :time_transference
      t.references :hospitalization_type, index: true
      t.date :date_intput
      t.date :date_output
      t.references :hospitalization_output_type, index: true
      t.integer :hospitalization_days
      t.boolean :is_hospitalary
      t.boolean :is_transference

      t.timestamps
    end
  end
end
