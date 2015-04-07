class CreateMechanismPayments < ActiveRecord::Migration
  def change
    create_table :mechanism_payments do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
