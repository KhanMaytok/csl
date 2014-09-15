class Authorization < ActiveRecord::Base
	belongs_to :patient
	belongs_to :doctor
	belongs_to :money
	belongs_to :clinic
	belongs_to :status

	has_many :diagnostics
end
