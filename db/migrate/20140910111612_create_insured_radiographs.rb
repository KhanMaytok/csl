class CreateInsuredRadiographs < ActiveRecord::Migration
  def change
    create_table :insured_radiographs do |t|
      t.integer :radiograph_id
      t.date :date
      t.time :time
      t.integer :doctor_id
      t.integer :insured_radiograph_type_id
      t.float :cop_fijo
      t.float :cop_var
      t.string :ticket_code
      t.float :amount
      t.integer :administration_id
      t.integer :admission_id
      t.boolean :is_printed

      t.timestamps
    end
  end
end
