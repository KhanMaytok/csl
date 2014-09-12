class CreateSubMechanismPayTypes < ActiveRecord::Migration
  def change
    create_table :sub_mechanism_pay_types do |t|
      t.integer :mechanism_payment_id
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
