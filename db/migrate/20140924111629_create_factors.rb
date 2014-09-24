class CreateFactors < ActiveRecord::Migration
  def change
    create_table :factors do |t|
      t.references :insurance, index: true
      t.references :clinic_area, index: true
      t.float :factor
      t.float :pharm
      t.float :bed

      t.timestamps
    end
  end
end
