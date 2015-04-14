class Insured < ActiveRecord::Base
	belongs_to :company
	belongs_to :afiliation_type
	belongs_to :insurance
	belongs_to :patient
	belongs_to :relation_ship

	has_many :pay_documents

	#validates :afiliation_type_id, :company_id, :insurance_id, :patient_id , :code, :hold_paternal, :hold_maternal, :hold_name, :relation_ship_id, presence: true
	validate :code, uniqueness: true
end