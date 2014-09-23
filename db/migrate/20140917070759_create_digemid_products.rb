class CreateDigemidProducts < ActiveRecord::Migration
  def change
    create_table :digemid_products do |t|
      t.string :code
      t.string :name
      t.string :concentration
      t.string :form
      t.string :form_simplificated
      t.string :presentation
      t.string :fractions
      t.date :due_date_sanitary
      t.string :sanitary_number
      t.string :holder_name

      t.timestamps
    end
  end
end
