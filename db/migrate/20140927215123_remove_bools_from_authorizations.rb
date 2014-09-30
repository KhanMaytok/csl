class RemoveBoolsFromAuthorizations < ActiveRecord::Migration
  def change
    remove_column :authorizations, :is_transference, :boolean
    remove_column :authorizations, :is_hospitalary, :boolean
  end
end
