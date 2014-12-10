class CreateDetailDentalGroups < ActiveRecord::Migration
  def change
    create_table :detail_dental_groups do |t|
      t.string :code
      t.string :name
      t.date :date
      t.time :time
      t.integer :quantity

      t.timestamps
    end
  end
end
