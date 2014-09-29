class AddAutColumnToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :second_authorization_type, :string
    add_column :benefits, :sexond_authorization_code, :string
  end
end
