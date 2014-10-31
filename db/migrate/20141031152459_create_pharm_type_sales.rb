class CreatePharmTypeSales < ActiveRecord::Migration
  def change
    create_table :pharm_type_sales do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
