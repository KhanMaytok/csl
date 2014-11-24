class CreateCategoryPossessions < ActiveRecord::Migration
  def change
    create_table :category_possessions do |t|
      t.integer :clinic_area_id
      t.integer :service_id

      t.timestamps
    end
  end
end
