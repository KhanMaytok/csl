class AddOtherNameToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :other_name, :string
  end
end
