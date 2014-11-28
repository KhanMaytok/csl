class CreateProductPharmTypes < ActiveRecord::Migration
  def change
    create_table :product_pharm_types do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
