class InsuredService < ActiveRecord::Base
  belongs_to :authorization
  belongs_to :doctor
  belongs_to :clinica_area
  belongs_to :employee

  has_many :purchase_insured_services
  has_many :purchase_coverage_services
end
