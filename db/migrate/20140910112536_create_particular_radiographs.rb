class CreateParticularRadiographs < ActiveRecord::Migration
  def change
    create_table :particular_radiographs do |t|
      t.string :radiograph_id
      t.date :date
      t.time :time
      t.integer :doctor_id
      t.integer :particular_radiograph_type_id
      t.integer :employee_id
      t.boolean :is_printed
      t.string :ticket_code

      t.timestamps
    end
  end
end
