class AddClinicHistoryCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :clinic_history_code, :string
  end
end
