class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.references :document_identity_type, index: true
      t.string :document_identity_code
      t.string :name
      t.string :paternal
      t.string :maternal
      t.date :birthday
      t.string :age
      t.string :sex
      t.references :employee, index: true
      t.string :phone
      t.string :clinic_history_code

      t.timestamps
    end
  end
end
