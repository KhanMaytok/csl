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
		a.consultations_quantity = params[:consultations_quantity]
		a.symptoms = params[:symptoms]
		a.is_transference = params[:is_transference]
		if (params[:diagnostic_type_id_1] != '' or !params[:diagnostic_type_id_1].nil?) and !Diagnostic.where(authorization: a, correlative: 1).exists?
			d = Diagnostic.new
			d.authorization_id = a.id
			d.diagnostic_type_id = params[:diagnostic_type_id_1]
			d.correlative = 1
			d.save
		end
		if (params[:diagnostic_type_id_2] != '' or !params[:diagnostic_type_id_2].nil?) and !Diagnostic.where(authorization: a, correlative: 1).exists?
			d = Diagnostic.new
			d.authorization_id = a.id
			d.diagnostic_type_id = params[:diagnostic_type_id_2]
			d.correlative = 2
			d.save
		end
		if (params[:diagnostic_type_id_3] != '' or !params[:diagnostic_type_id_3].nil?) and !Diagnostic.where(authorization: a, correlative: 1).exists?
			d = Diagnostic.new
			d.authorization_id = a.id
			d.diagnostic_type_id = params[:diagnostic_type_id_3]
			d.correlative = 3
			d.save
		end
		if a.ruc_transference != ''
			a.is_transference = 1
		end
		if a.is_transference
			a.is_transference = 1	
			if a.ruc_transference != '' or !a.ruc_transference.nil?
				a.ruc_transference = params[:ruc_transference]			
			end		
			if a.date_transference != '' or !a.date_transference.nil?
				a.date_transference = params[:date_transference]			
			end
			if a.time_transference != '' or !a.time_transference.nil?
				a.time_transference = params[:time_transference]			
			end
		end
		a.save
	end
end
