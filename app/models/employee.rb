class Employee < ActiveRecord::Base
	has_many :patients
	has_many :insured_services
	belongs_to :area

	def is?( requested_role )
		case requested_role
		when :admin
			aa = 1
		when :sistemas
			aa = 8
		when :caja
			aa = 2
		when :farm
			aa = 3
		when :lab
			aa = 4
		when :imag
			aa = 5
		when :fact			
			aa = 6	
		end
		self.area == Area.find(aa)
	end
end
