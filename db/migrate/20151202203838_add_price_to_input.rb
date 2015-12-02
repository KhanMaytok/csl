class AddPriceToInput < ActiveRecord::Migration
  def change
    add_column :inputs, :price, :float
  end
end
