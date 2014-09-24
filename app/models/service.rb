class Service < ActiveRecord::Base
	belongs_to :clinic_area
	has_many :purchase_insureds
end
