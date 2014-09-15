class CreateFactors < ActiveRecord::Migration
  def change
    create_table :factors do |t|
      t.integer :insurance_id
      t.integer :clinic_area_id
      t.float :factor

      t.timestamps
    end
  end
end
