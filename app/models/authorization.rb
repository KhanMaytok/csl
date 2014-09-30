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

	after_create :set_columns

	def self.update_info(params)
		a = Authorization.find(params[:id])
		a.status_id = params[:status_id]
		a.doctor_id = params[:doctor_id]
		a.has_record = params[:has_record]
		a.consultations_quantity = params[:consultations_quantity]
		a.symptoms = params[:symptoms]
		if params[:first_diagnostic_code] == ''
			a.first_diagnostic = params[:first_diagnostic]
		else
			a.first_diagnostic = params[:first_diagnostic_code]
		end
		if params[:second_diagnostic_code] == ''
			a.second_diagnostic = params[:second_diagnostic]
		else
			a.second_diagnostic = params[:second_diagnostic_code]
		end
		if params[:third_diagnostic_code] == ''
			a.third_diagnostic = params[:third_diagnostic]
		else
			a.third_diagnostic = params[:third_diagnostic_code]
		end
		a.ruc_transference = params[:ruc_transference]
		a.date_transference = params[:date_transference]
		#Validar time_transference
		hour = params[:date][:hour]
		minute = params[:date][:minute]
		a.time_transference = hour + ":" + minute +":00"
		a.hospitalization_type_id = params[:hospitalization_type_id]
		a.date_intput = params[:date_input]
		a.hospitalization_output_type_id = params[:hospitalization_output_type_id]
		a.date_output = params[:date_output]
		a.hospitalization_days = params[:hospitalization_days]
		a.save
	end

	def self.evalue(cadena)
		if !!cadena
			return cadena
		else
			return nil
		end
	end
end
