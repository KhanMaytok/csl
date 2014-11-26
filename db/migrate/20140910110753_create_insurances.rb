class CreateInsurances < ActiveRecord::Migration
  def change
    create_table :insurances do |t|
      t.string :code
      t.string :name
      t.string :fact_code

      t.timestamps
    end
  end
end
