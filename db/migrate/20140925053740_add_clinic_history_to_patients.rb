class AddClinicHistoryToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :clinic_history, :string
  end
end
