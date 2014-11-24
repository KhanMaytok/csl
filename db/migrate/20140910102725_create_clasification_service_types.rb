class CreateClasificationServiceTypes < ActiveRecord::Migration
  def change
    create_table :clasification_service_types do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
