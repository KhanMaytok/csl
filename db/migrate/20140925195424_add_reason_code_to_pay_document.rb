class AddReasonCodeToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :reason_code, :string
  end
end
