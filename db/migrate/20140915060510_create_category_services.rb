class CreateCategoryServices < ActiveRecord::Migration
  def change
    create_table :category_services do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
