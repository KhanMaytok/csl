class CreateCumSunasaProducts < ActiveRecord::Migration
  def change
    create_table :cum_sunasa_products do |t|
      t.string :code
      t.string :name
      t.string :form
      t.string :owner
      t.string :manufacturer
      t.string :report_unity
      t.string :measure
      t.string :measure_unity
      t.string :posologic_unity
      t.string :atc_code_atc_name

      t.timestamps
    end
  end
end
