class CreateDrugstoreAttentions < ActiveRecord::Migration
  def change
    create_table :drugstore_attentions do |t|
      t.integer :authorization_id
      t.date :date
      t.time :time
      t.integer :doctor_id
      t.string :amount
      t.string :float

      t.timestamps
    end
  end
end
