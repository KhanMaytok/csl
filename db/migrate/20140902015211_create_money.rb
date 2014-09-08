class CreateMoney < ActiveRecord::Migration
  def change
    create_table :money do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
