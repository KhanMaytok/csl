class InsuredService < ActiveRecord::Base
	has_many :purchase_insured_services
	belongs_to :authorization
	belongs_to :employee
	belongs_to :clinic_area
end
