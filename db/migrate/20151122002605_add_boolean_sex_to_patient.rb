class AddBooleanSexToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :boolean_sex, :boolean
  end
end
