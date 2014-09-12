class CreateInsureds < ActiveRecord::Migration
  def change
    create_table :insureds do |t|
      t.integer :afiliation_type_id
      t.integer :company_id
      t.integer :insurance_id
      t.integer :patient_id
      t.string :code
      t.string :hold_paternal
      t.string :hold_name
      t.date :validity_id
      t.date :validity_f
      t.date :inclusion_date
      t.integer :relation_ship_id
      t.string :card_number

      t.timestamps
    end
  end
end
