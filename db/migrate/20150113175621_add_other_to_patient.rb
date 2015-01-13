class AddOtherToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :other, :text
  end
end
