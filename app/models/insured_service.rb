class InsuredService < ActiveRecord::Base
  belongs_to :authorization
  belongs_to :doctor
  belongs_to :clinic_area
  belongs_to :employee

  has_many :purchase_insured_services
  has_one :purchase_coverage_service
end
