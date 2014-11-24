class CreateMoney < ActiveRecord::Migration
  def change
    create_table :money do |t|
      t.string :code
      t.string :fact_code
      t.string :name

      t.timestamps
    end
  end
end
