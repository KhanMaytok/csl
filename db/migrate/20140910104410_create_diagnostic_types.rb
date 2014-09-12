class CreateDiagnosticTypes < ActiveRecord::Migration
  def change
    create_table :diagnostic_types do |t|
      t.integer :diagnostic_category_id
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
