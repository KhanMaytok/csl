class CreateProductPharmExenteds < ActiveRecord::Migration
  def change
    create_table :product_pharm_exenteds do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
