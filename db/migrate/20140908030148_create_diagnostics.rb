class CreateDiagnostics < ActiveRecord::Migration
  def change
    create_table :diagnostics do |t|
      t.integer :diagnostic_category_id
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
