class Insured < ActiveRecord::Base
	belongs_to :company
	belongs_to :afiliation_type
	belongs_to :insurance
	belongs_to :patient
	belongs_to :relation_ship

	has_many :pay_documents
end
