class AddIsInsuredToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :is_insured, :boolean
  end
end
