class CreateDoctors < ActiveRecord::Migration
  def change
    create_table :doctors do |t|
      t.integer :speciality_id
      t.string :tuition_code
      t.string :dni
      t.string :card_number
      t.string :name
      t.string :paternal
      t.string :maternal
      t.float :to_clinic
      t.float :to_doctor

      t.timestamps
    end
  end
end
