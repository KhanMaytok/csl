class AddEmployeeToAuthorization < ActiveRecord::Migration
  def change
    add_reference :authorizations, :employee, index: true
  end
end
