class CreateAuthorizationTypes < ActiveRecord::Migration
  def change
    create_table :authorization_types do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
