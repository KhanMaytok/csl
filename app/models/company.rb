class Company < ActiveRecord::Base
	has_many :insureds

	before_create :set_name

	def set_name
		self.name = self.name.upcase
	end
end
