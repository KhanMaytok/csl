class CreateAfiliationTypes < ActiveRecord::Migration
  def change
    create_table :afiliation_types do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
