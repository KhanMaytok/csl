class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
