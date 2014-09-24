class Factor < ActiveRecord::Base
  belongs_to :insurance
  belongs_to :clinic_area
end
