class RemoveClinicHistoryFromPatient < ActiveRecord::Migration
  def change
    remove_column :patients, :clinic_history, :string
  end
end
