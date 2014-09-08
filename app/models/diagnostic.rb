class Diagnostic < ActiveRecord::Base
	belongs_to :diagnostic_category
	has_many :exclusions
end
