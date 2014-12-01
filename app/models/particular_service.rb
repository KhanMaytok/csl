class ParticularService < ActiveRecord::Base
  belongs_to :authorization
  belongs_to :doctor
  belongs_to :clinic_area
  belongs_to :employee
end
