class InsuredService < ActiveRecord::Base
  belongs_to :authorization
  belongs_to :doctor
  belongs_to :clinica_area
  belongs_to :employee
end
