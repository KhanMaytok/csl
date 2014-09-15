class CreateSubCategoryServices < ActiveRecord::Migration
  def change
    create_table :sub_category_services do |t|
      t.integer :category_service_id
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
