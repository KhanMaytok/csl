class Doctor < ActiveRecord::Base
	belongs_to :speciality
	belongs_to :document_identity_type

	has_many :authorizations
end
