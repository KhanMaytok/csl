class CreateAreaProviders < ActiveRecord::Migration
  def change
    create_table :area_providers do |t|
      t.integer :provider_id
      t.integer :area_id

      t.timestamps
    end
  end
end
