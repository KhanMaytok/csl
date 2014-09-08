class CreateInsureds < ActiveRecord::Migration
  def change
    create_table :insureds do |t|
      t.integer :afiliation_type_id
      t.integer :company_id
      t.integer :insurance_id
      t.string :code
      t.string :dni
      t.string :paternal
      t.string :maternal
      t.string :name
      t.string :hold_paternal
      t.string :hold_maternal
      t.string :hold_name
      t.string :birthday
      t.string :age
      t.string :sex
      t.date :validity_i
      t.date :validity_f
      t.date :inclusion_date
      t.integer :relationship_id
      t.string :card_number
      t.text :observation

      t.timestamps
    end
  end
end
