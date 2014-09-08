class Coverage < ActiveRecord::Base
	belongs_to :authorization
	belongs_to :coverage_type
	belongs_to :service
end
