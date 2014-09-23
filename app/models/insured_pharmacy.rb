class InsuredPharmacy < ActiveRecord::Base
	belongs_to :authorization
	belongs_to :doctor
	belongs_to :employee
	belongs_to :clinic_area

	has_many :purchase_i_pharmacies
end
