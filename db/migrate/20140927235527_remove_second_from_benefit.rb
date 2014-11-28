class RemoveSecondFromBenefit < ActiveRecord::Migration
  def change
    remove_column :benefits, :sexond_authorization_code, :string
  end
end
