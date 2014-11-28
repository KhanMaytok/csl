class CreateDiagnostics < ActiveRecord::Migration
  def change
    create_table :diagnostics do |t|
      t.references :authorization, index: true
      t.references :diagnostic_type, index: true
      t.integer :correlative

      t.timestamps
    end
  end
end
