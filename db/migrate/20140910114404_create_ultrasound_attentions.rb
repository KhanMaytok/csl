class CreateUltrasoundAttentions < ActiveRecord::Migration
  def change
    create_table :ultrasound_attentions do |t|
      t.integer :authorization_id
      t.float :amount

      t.timestamps
    end
  end
end
