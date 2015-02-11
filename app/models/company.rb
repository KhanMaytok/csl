class Company < ActiveRecord::Base
	has_many :insureds
	validates :ruc, :name, presence: true
	validate :ruc, uniqueness: true
	before_create :set_name

	def set_name
		self.name = self.name.upcase
	end
end
