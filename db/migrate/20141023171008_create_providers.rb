class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.references :provider_type, index: true
      t.references :clinic_area, index: true
      t.string :name
      t.references :doctor, index: true
      t.string :ruc

      t.timestamps
    end
  end
end
