class Message < ActiveRecord::Base

	self.per_page = 20
	belongs_to :employee
end
