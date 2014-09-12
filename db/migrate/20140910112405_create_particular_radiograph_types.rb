class CreateParticularRadiographTypes < ActiveRecord::Migration
  def change
    create_table :particular_radiograph_types do |t|
      t.string :code
      t.string :name
      t.float :price

      t.timestamps
    end
  end
end
