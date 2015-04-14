class RemoveCinicAreaFromProvider < ActiveRecord::Migration
  def change
    remove_reference :providers, :clinic_area, index: true
  end
end
