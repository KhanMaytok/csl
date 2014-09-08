class CreateDiagnosticCategories < ActiveRecord::Migration
  def change
    create_table :diagnostic_categories do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
