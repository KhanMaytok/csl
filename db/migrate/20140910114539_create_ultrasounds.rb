class CreateUltrasounds < ActiveRecord::Migration
  def change
    create_table :ultrasounds do |t|
      t.string :ultrasound_attention_id
      t.integer :ultrasound_attention_id
      t.integer :ultrasound_type_id
      t.float :cop_fijo
      t.float :cop_var
      t.float :amount
      t.string :ticket_code
      t.date :date
      t.time :time

      t.timestamps
    end
  end
end
