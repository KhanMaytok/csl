class CreateServiceExenteds < ActiveRecord::Migration
  def change
    create_table :service_exenteds do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
