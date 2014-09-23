class Employee < ActiveRecord::Base
	has_many :patients
	has_many :insured_services
end
