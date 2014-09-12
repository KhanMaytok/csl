class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.integer :document_identity_type_id
      t.string :document_identity_code
      t.string :name
      t.string :paternal
      t.string :maternal
      t.date :birthday
      t.string :age
      t.string :sex
      t.integer :employee_id
      t.string :clinic_history_code

      t.timestamps
    end
  end
end
