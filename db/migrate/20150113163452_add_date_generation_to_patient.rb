class AddDateGenerationToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :date_generation, :date
  end
end
