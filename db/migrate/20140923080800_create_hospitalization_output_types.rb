class CreateHospitalizationOutputTypes < ActiveRecord::Migration
  def change
    create_table :hospitalization_output_types do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
