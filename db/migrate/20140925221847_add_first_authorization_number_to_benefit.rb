class AddFirstAuthorizationNumberToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :first_authorization_number, :string
  end
end
