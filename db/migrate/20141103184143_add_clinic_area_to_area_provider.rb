class AddClinicAreaToAreaProvider < ActiveRecord::Migration
  def change
    add_reference :area_providers, :clinic_area, index: true
  end
end
