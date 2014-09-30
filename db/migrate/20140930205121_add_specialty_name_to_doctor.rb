class AddSpecialtyNameToDoctor < ActiveRecord::Migration
  def change
    add_column :doctors, :specialty_name, :string
  end
end
