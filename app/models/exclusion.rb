class Exclusion < ActiveRecord::Base
	belongs_to :authorizations
	belongs_to :diagnostic
end
