class CreateUltrasoundTypes < ActiveRecord::Migration
  def change
    create_table :ultrasound_types do |t|
      t.string :code
      t.string :name
      t.float :price

      t.timestamps
    end
  end
end
