class CreateRelationShips < ActiveRecord::Migration
  def change
    create_table :relation_ships do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
