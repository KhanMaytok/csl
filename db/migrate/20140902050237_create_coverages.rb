class CreateCoverages < ActiveRecord::Migration
  def change
    create_table :coverages do |t|
      t.integer :authorization_id
      t.integer :coverage_type_id
      t.integer :service_id
      t.float :cop_fijo
      t.float :cop_var
      t.integer :quantity
      t.string :procedure_indicator

      t.timestamps
    end
  end
end
