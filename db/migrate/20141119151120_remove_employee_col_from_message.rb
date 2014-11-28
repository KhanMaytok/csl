class RemoveEmployeeColFromMessage < ActiveRecord::Migration
  def change
    remove_column :messages, :employee_id_id, :integer
  end
end
