class DetailServiceGroup < ActiveRecord::Base
	has_many :detail_services

	after_create :set_columns

	def set_columns
		ruc = Clinic.find(1).ruc
		code = Clinic.find(1).code
		self.name = 'dser_'+ruc+'_'+code+'_'+self.code+'_'+self.date.strftime('%Y%m%d')+'.txt'
		self.save
	end

	def print
		File.open("/home/and/Desktop/andpc/tedef/"+self.code+"/"+self.name, 'w:ANSI') do |f|
			f.puts (get_line(self.detail_services.all))
		end

		File.open("/home/and/Desktop/facturacion/lotes/"+self.code+"/"+self.name, 'w:ANSI') do |f| 
			f.puts (get_line(self.detail_services.all))
		end
		
	end

	def get_line(ds)
		string_return = ''
		self.detail_services.each do |ds|
			clinic_ruc = ds.clinic_ruc
			clinic_code = ds.clinic_code
			payment_type_document = '01'
			payment_document = ds.payment_document
			correlative_benefit = '00001'
			correlative = ds.correlative.to_s.rjust(4, '0')
			clasification_code = '03'
			service_code = ds.service_code.ljust(10, ' ')
			service_description = ds.service_description[0,70].rjust(70, ' ')
			date = ds.date.strftime('%Y%m%d')
			professional_type = ds.professional_type
			tuition_code = ds.tuition_code.rjust(6,' ')
		 	quantity = ds.quantity.to_i.to_s.rjust(5,' ')
		 	unitary = ("%.2f" % ds.unitary).rjust(12, ' ')
		 	copayment = ("%.2f" % ds.copayment).rjust(12, ' ')
		 	amount = ("%.2f" % ds.amount).rjust(12, ' ')
		 	amount_not_covered = ("%.2f" % ds.amount_not_covered).rjust(12, ' ')
		 	diagnostic = ds.diagnostic_code
		 	exented_code = ds.exented_code
		 	sector_code = ds.sector_code
		 	string_return = string_return << clinic_ruc+clinic_code+payment_type_document+payment_document+correlative_benefit+correlative+clasification_code+service_code+service_description+date+professional_type+tuition_code+quantity+unitary+copayment+amount+amount_not_covered+diagnostic+exented_code+sector_code + "\r\n"
		end
		return string_return
	end
end
