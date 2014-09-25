class AddInternCodeToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :intern_code, :string
  end
end
