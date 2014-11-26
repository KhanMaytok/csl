class AddOtherColToMessage < ActiveRecord::Migration
  def change
    add_reference :messages, :employee_id, index: true
    add_column :messages, :body, :text
  end
end
