class CreateMedicalInputs < ActiveRecord::Migration
  def change
    create_table :medical_inputs do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
