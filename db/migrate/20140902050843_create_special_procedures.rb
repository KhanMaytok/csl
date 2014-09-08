class CreateSpecialProcedures < ActiveRecord::Migration
  def change
    create_table :special_procedures do |t|
      t.integer :authorization_id
      t.integer :coverage_type_id
      t.integer :procedure_type_id
      t.float :deductible
      t.float :percentage_coverade

      t.timestamps
    end
  end
end
