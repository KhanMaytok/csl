class Patient < ActiveRecord::Base
	belongs_to :document_identity_type
	belongs_to :employee

	has_one :insured
	has_many :authorizations
end
