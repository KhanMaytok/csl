class CreateEanProducts < ActiveRecord::Migration
  def change
    create_table :ean_products do |t|
      t.string :code
      t.string :name
      t.string :concentration
      t.string :form
      t.string :form_simplificated
      t.string :presentation
      t.string :fractions
      t.date :due_date_sanitary
      t.string :number_sanitary
      t.string :holder_name

      t.timestamps
    end
  end
end
