class AddSecondToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :second_authorization_code, :string
  end
end
