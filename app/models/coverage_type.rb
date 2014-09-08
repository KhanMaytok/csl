class CoverageType < ActiveRecord::Base
	has_many :coverages
	has_many :special_procedures
end
