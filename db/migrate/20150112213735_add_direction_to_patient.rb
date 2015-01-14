class AddDirectionToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :direction, :string
  end
end
