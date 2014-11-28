class AddClinicColumnToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :clinic_code, :string
    add_column :benefits, :clinic_ruc, :string
  end
end
