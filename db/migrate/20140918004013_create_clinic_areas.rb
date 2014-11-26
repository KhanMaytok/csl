class CreateClinicAreas < ActiveRecord::Migration
  def change
    create_table :clinic_areas do |t|
      t.string :name
      t.integer :tedef_area_id

      t.timestamps
    end
  end
end
