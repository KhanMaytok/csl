class Insurance < ActiveRecord::Base
	has_many :procedure_types
	has_many :insureds
end
