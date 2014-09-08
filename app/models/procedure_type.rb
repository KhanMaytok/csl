class ProcedureType < ActiveRecord::Base

	belongs_to :insurance
	self.per_page = 150
	has_many :special_procedures
end
