class CreateNomenclatorServices < ActiveRecord::Migration
  def change
    create_table :nomenclator_services do |t|
      t.string :code
      t.string :name
      t.string :contable_group
      t.string :contable_name

      t.timestamps
    end
  end
end
