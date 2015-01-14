class AddIsMonsantoToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :is_monsanto, :boolean
  end
end
