class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :employee_id
      t.string :body

      t.timestamps
    end
  end
end
