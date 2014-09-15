class CreateDoctors < ActiveRecord::Migration
  def change
    create_table :doctors do |t|
      t.string :tuition_code
      t.integer :document_identity_type_id
      t.string :document_identity_code
      t.string :card_number
      t.string :name
      t.string :paternal
      t.string :maternal
      t.string :to_clinic
      t.string :to_doctor
      t.integer :speciality_id

      t.timestamps
    end
  end
end
