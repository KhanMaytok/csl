class Insurance < ActiveRecord::Base
	has_many :insureds
	has_many :factors
end
