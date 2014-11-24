class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
