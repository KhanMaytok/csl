class CreateTedefAreas < ActiveRecord::Migration
  def change
    create_table :tedef_areas do |t|
      t.string :name

      t.timestamps
    end
  end
end
