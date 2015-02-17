class Service < ActiveRecord::Base
	belongs_to :clinic_area
	has_many :purchase_insured_services

	validates :contable_code, numericality: true

	self.per_page = 100

	def is_print
		flag = true
		Service.where('id in (1561,1562,1576,1563,1565,1566)').all.each do |s|
			if s.id == self.id
				flag = false
				break
			else
				flag = true
			end
		end
		flag
	end
end
