class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.integer :insured_id
      t.integer :money_id
      t.integer :clinic_id
      t.string :code
      t.datetime :date

      t.timestamps
    end
  end
end
