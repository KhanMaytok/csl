class AddAuthorizationTypeToAuthorization < ActiveRecord::Migration
  def change
    add_reference :authorizations, :authorization_type, index: true
  end
end
