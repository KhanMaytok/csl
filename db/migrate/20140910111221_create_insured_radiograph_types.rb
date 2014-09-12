class CreateInsuredRadiographTypes < ActiveRecord::Migration
  def change
    create_table :insured_radiograph_types do |t|
      t.string :code
      t.string :name
      t.float :price
      t.float :cop_fijo
      t.float :cop_var
      t.float :porc_cop_var
      t.integer :insurance_id

      t.timestamps
    end
  end
end
