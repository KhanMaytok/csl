class Authorization < ActiveRecord::Base	
	belongs_to :patient
	belongs_to :money
	belongs_to :clinic
	belongs_to :status
	belongs_to :doctor
	belongs_to :product
	belongs_to :employee
	belongs_to :hospitalization_type
	belongs_to :hospitalization_output_type
	belongs_to :authorization_type
	has_one :coverage, dependent: :destroy

	has_many :pay_documents, dependent: :destroy
	has_many :diagnostics, dependent: :destroy
	has_many :insured_services, dependent: :destroy
	has_many :insured_pharmacies, dependent: :destroy
	belongs_to :diagnostic_type, foreign_key: "first_diagnostic", primary_key: "code"
	before_create :set_columns

	after_create :set_time

	scope :diagnostics, ->(coverage_type_id) { joins(coverage: :sub_coverage_type).where("sub_coverage_types.coverage_type_id = #{coverage_type_id}").select('first_diagnostic, count(first_diagnostic) as total').group('first_diagnostic').order('total DESC').limit(11) }

	def self.update_info(params)
		a = Authorization.find(params[:id])
		a.status_id = params[:status_id]
		a.doctor_id = params[:doctor_id]
		a.has_record = params[:has_record]
		if params[:flag] == '1'
			c = Coverage.create(authorization_id: a.id)
			c.cop_fijo = params[:cop_fijo]
			c.cop_var = params[:cop_var]
			c.sub_coverage_type_id = params[:sub_coverage_type_id]
			c.name = CoverageType.find(SubCoverageType.find(c.sub_coverage_type_id).coverage_type.id)
			c.save
		else
			c = a.coverage
			c.cop_fijo = params[:cop_fijo]
			c.cop_var = params[:cop_var]
			c.sub_coverage_type_id = params[:sub_coverage_type_id]
			c.save
		end

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
		hour = "00"
		minute = "00"
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

	def insurance
		self.patient.insured.insurance
	end

	def set_columns  
		intern_code = Authorization.maximum('convert(intern_code, decimal)').to_i + 1
		
		self.intern_code = intern_code
	end



	def set_time
		self.date = self.date - 5.hours
		self.save
	end

end


# 2015 pacientes con ira infecciones respiratorias
# hemorragia en segundo trimestre embarazo 2015