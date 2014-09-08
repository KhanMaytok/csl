class Insured < ActiveRecord::Base
	belongs_to :afiliation_type
	belongs_to :insurance
	belongs_to :company
	belongs_to :relationship

	has_many :authorizations
end
