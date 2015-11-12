class AddInsuranceToPayDocument < ActiveRecord::Migration
  def change
    add_reference :pay_documents, :insurance, index: true
  end
end
