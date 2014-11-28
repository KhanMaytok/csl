class AddEmployeeColToMessage < ActiveRecord::Migration
  def change
    add_reference :messages, :employee, index: true
  end
end
