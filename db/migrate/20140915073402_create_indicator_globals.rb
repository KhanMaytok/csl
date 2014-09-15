class CreateIndicatorGlobals < ActiveRecord::Migration
  def change
    create_table :indicator_globals do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
