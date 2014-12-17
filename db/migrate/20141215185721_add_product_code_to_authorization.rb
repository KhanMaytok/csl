class AddProductCodeToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :product_code, :string
  end
end
