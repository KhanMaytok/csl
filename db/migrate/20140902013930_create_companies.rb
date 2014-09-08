class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :number
      t.string :ruc
      t.string :plan
      t.string :name

      t.timestamps
    end
  end
end
