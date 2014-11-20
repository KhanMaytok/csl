class RemoveSomeColFromMessage < ActiveRecord::Migration
  def change
    remove_column :messages, :employee_id, :string
    remove_column :messages, :body, :string
  end
end
