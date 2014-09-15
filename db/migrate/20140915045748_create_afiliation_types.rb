class CreateAfiliationTypes < ActiveRecord::Migration
  def change
    create_table :afiliation_types do |t|
      t.string :code
      t.string :fac_code
      t.string :name

      t.timestamps
    end
  end
end
