class SpecialProcedure < ActiveRecord::Base
	belongs_to :procedure_type
	belongs_to :coverage_type
	belongs_to :procedure_type
	belongs_to :authorization
end
