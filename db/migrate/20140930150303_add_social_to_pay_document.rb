class AddSocialToPayDocument < ActiveRecord::Migration
  def change
    add_column :pay_documents, :social, :string
  end
end
