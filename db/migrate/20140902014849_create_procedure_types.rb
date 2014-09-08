class CreateProcedureTypes < ActiveRecord::Migration
  def change
    create_table :procedure_types do |t|
      t.integer :insurance_id
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
