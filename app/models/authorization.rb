class Authorization < ActiveRecord::Base
  belongs_to :patient
  belongs_to :money
  belongs_to :clinic
  belongs_to :status
  belongs_to :doctor
  belongs_to :product
  belongs_to :hospitalization_type
  belongs_to :hospitalization_output_type

  has_one :coverage

  has_many :pay_documents

  has_many :diagnostics
	has_many :insured_services
	has_many :insured_pharmacies
	has_one :coverage

	def self.update_info(params)
		a = Authorization.find(params[:id])
		a.status_id = params[:status_id]
		a.doctor_id = params[:doctor_id]
		a.has_record = params[:has_record]
		a.symptoms = params[:symptoms]
		a.save
	end
end
