class AddFirstAuthorizationTypeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :first_authorization_type, :string
  end
end
