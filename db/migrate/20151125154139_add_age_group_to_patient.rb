class AddAgeGroupToPatient < ActiveRecord::Migration
  def change
    add_reference :patients, :age_group, index: true
  end
end
