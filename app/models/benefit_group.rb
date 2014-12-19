class BenefitGroup < ActiveRecord::Base
	has_many :benefits

	after_create :set_columns
	after_save :with_save

	@@lotes_path = '/home/fabian/facturacion/Lotes/'

	def set_columns
		ruc = Clinic.find(1).ruc
		code = Clinic.find(1).code
		self.name = 'date_'+ruc+'_'+code+'_'+self.code+'_'+self.date.strftime('%Y%m%d')+'.txt'
		self.dental_name = 'dden_'+ruc+'_'+code+'_'+self.code+'_'+self.date.strftime('%Y%m%d')+'.txt'

		self.save
	end

	def with_save
				
	end

	def print
		ds = DetailServiceGroup.create(code: self.code, date: self.date)
		dp = DetailPharmacyGroup.create(code: self.code, date: self.date)
		dd = DetailDentalGroup.create(code: self.code, date: self.date)
		self.benefits.each do |b|
			b.detail_services.each do |d|
				d.detail_service_group_id = ds.id
				d.save
			end
			b.detail_pharmacies.each do |d|
				d.detail_pharmacy_group_id = dp.id
				d.save
			end
			b.detail_dentals.each do |d|
				d.detail_dental_group_id = dd.id
				d.save
			end
		end
=begin
		File.open("/home/and/Desktop/andpc/tedef/"+self.code+"/"+self.name, 'w') do |f| 
			f.puts (get_line(self.benefits.all))
		end
		File.open("/home/and/Desktop/andpc/tedef/"+self.code+"/"+self.dental_name, 'w') do |f| 
			 
		end
=end
		File.open(@@lotes_path+self.code+"/"+self.name, 'w') do |f| 
			f.puts (get_line(self.benefits.all))	
		end
	end

	def get_line(b)
		string_return = ''
		self.benefits.each do |b|
			clinic = Clinic.find(1)
			clinic_ruc = clinic.ruc
			clinic_code = clinic.code
			document_type = '01'
			document_code = b.pay_document.code.rjust(12, ' ')
			correlative = '00001'
			intern_code = b.intern_code.rjust(10, '0')
			afiliation_type = b.afiliation_type_code
			insured_code = b.insured_code.ljust(22,' ')
			document_identity_type_code = '1'
			document_identity_code = b.document_identity_code[0,8].ljust(15, ' ')
			clinic_history_code = b.clinic_history_code.ljust(8, " ")
			first_authorization_type= b.first_authorization_type.to_s.rjust(2,'0')
			first_authorization_number = b.first_authorization_number.ljust(12, ' ')
			if b.second_authorization_type == nil or b.second_authorization_type == '' or b.second_authorization_type == '99'
				second_authorization_type = "99"
				second_authorization_code = " "*12
			else
				second_authorization_type = b.second_authorization_type
				second_authorization_code = b.second_authorization_code.ljust(12, ' ')
			end		
			coverage_type_code = b.coverage_type_code
			sub_type_coverage_code = b.sub_type_coverage_code.ljust(3, ' ')
			first_diagnostic = b.first_diagnostic.ljust(5,' ')
			second_diagnostic = b.second_diagnostic.ljust(5,' ')
			third_diagnostic = b.third_diagnostic.ljust(5,' ')
			date = b.date.strftime('%Y%m%d')
			time = b.time.strftime('%H%M%S')
			type_professional_code = b.type_professional_code
			tuition_code = b.tuition_code.ljust(6, ' ')
			professional_identity_type_code = b.professional_identity_type_code
			professional_identity_code = b.professional_identity_code.ljust(15, ' ')
			ruc_extern_entity = b.ruc_extern_entity
			if ruc_extern_entity == '20494306043'
				transference_date = " "*8
				transference_time = " "*6
			else
				transference_date = b.transference_date.strftime('%Y%m%d').rjust(8,' ')
				transference_time = b.transference_time.strftime('%H%M%S').rjust(6,' ')
			end

			hospitalization_type_code = b.hospitalization_type_code.rjust(1,'X')
			if b.hospitalization_type_code == ' ' or b.hospitalization_type_code == 'X' or hospitalization_type_code.nil?
				admission_date = ' '*8
				discharge_date = ' '*8
			else
				admission_date = b.admission_date.strftime('%Y%m%d').rjust(8,' ')
				discharge_date = b.discharge_date.strftime('%Y%m%d').rjust(8,' ')	
			end		
			hospitalization_output_type_code = b.hospitalization_output_type_code.ljust(2,' ')
			if b.days_hospitalization == '0' or b.days_hospitalization == 0
				days_hospitalization = ' '*3
			else
				days_hospitalization = b.days_hospitalization.to_s.ljust(3,' ')
			end
			if b.expense_pharmacy.nil? or b.expense_pharmacy == ''
				b.expense_pharmacy = 0
			end
			expense_fee = ("%.2f" % b.expense_fee.to_f).to_s.rjust(12,' ')
			expense_dental = ("%.2f" % b.expense_dental.to_f).to_s.rjust(12,' ')
			expense_hotelery = ("%.2f" % b.expense_hotelery.to_f).to_s.rjust(12,' ')
			expense_aux_lab = ("%.2f" % b.expense_aux_lab.to_f).to_s.rjust(12,' ')
			expense_aux_img = ("%.2f" % b.expense_aux_img.to_f).to_s.rjust(12,' ')
			expense_pharmacy = ("%.2f" % b.expense_pharmacy.to_f).to_s.rjust(12,' ')
			expense_prosthesis = ("%.2f" % b.expense_prosthesis.to_f).to_s.rjust(12,' ')
			expense_medicaments_exonerated = ("%.2f" % b.expense_medicaments_exonerated).to_s.rjust(12,' ')
			expense_other = ("%.2f" % b.expense_other).to_s.rjust(12,' ')
			cop_fijo = ("%.2f" % b.cop_fijo).to_s.rjust(12,' ')
			cop_var = ("%.2f" % b.cop_var).to_s.rjust(12,' ')
			total_expense = ("%.2f" % b.total_expense).to_s.rjust(12,' ')
			string_return = string_return << clinic_ruc+clinic_code+document_type+document_code+correlative+intern_code+afiliation_type+insured_code+document_identity_type_code+document_identity_code+clinic_history_code+first_authorization_type+first_authorization_number+second_authorization_type+second_authorization_code+coverage_type_code+sub_type_coverage_code+first_diagnostic+second_diagnostic+third_diagnostic+date+time+type_professional_code+tuition_code+"1"+professional_identity_code+ruc_extern_entity+transference_date+transference_time+hospitalization_type_code+admission_date+discharge_date+hospitalization_output_type_code+days_hospitalization+expense_fee+expense_dental+expense_hotelery+expense_aux_lab+expense_aux_img+expense_pharmacy+expense_prosthesis+expense_medicaments_exonerated+expense_other+cop_fijo+cop_var+total_expense + "\r\n"
		end
		return string_return
	end
end
