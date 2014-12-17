class Service < ActiveRecord::Base
	belongs_to :clinic_area
	has_many :purchase_insureds

	def is_print
		flag = true
		Service.where('id in (1561,1562,1576)').all.each do |s|
			if s.id == Service.find_by_code(self.code).id
				flag = false
				break
			else
				flag = true
			end
		end
		flag
	end
end
