class CreateClinicAreas < ActiveRecord::Migration
  def change
    create_table :clinic_areas do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
