class AddEmployeeToPayDocument < ActiveRecord::Migration
  def change
    add_reference :pay_documents, :employee, index: true
  end
end
