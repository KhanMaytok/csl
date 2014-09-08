class Authorization < ActiveRecord::Base
	belongs_to :insured

	has_many :coverages
	has_many :exclusions
	has_many :special_procedures
end
