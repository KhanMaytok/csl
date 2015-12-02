class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.string :name
      t.references :input_type, index: true

      t.timestamps
    end
  end
end
