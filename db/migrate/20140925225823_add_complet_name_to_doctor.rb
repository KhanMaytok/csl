class AddCompletNameToDoctor < ActiveRecord::Migration
  def change
    add_column :doctors, :complet_name, :string
  end
end
