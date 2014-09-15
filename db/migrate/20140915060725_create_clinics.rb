class CreateClinics < ActiveRecord::Migration
  def change
    create_table :clinics do |t|
      t.string :code
      t.string :fac_code
      t.string :ruc

      t.timestamps
    end
  end
end
