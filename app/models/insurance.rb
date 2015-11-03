class Insurance < ActiveRecord::Base
	has_many :insureds
	has_many :factors

	after_create :set_factors

	def set_factors
		8.times do |t|
			self.factors.create(clinic_area_id: t + 1, factor: 1)
		end
	end
end
