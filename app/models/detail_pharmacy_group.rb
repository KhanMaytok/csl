class DetailPharmacyGroup < ActiveRecord::Base
	has_many :detail_pharmacies

	after_create :set_columns

	def set_columns
		ruc = Clinic.find(1).ruc
		code = Clinic.find(1).code
		self.name = 'dfar_'+ruc+'_'+code+'_'+self.code+'_'+self.date.strftime('%Y%m%d')+'.txt'
		self.save
	end

	def print
		File.open("C:/prueba/tedef/"+self.code+"/"+self.name, 'w') do |f| 
			self.detail_pharmacies.each do |dp|
				f.puts (get_line(dp)+"\n")
			end  			
		end 
	end

	def get_line(dp)
		clinic_ruc = dp.clinic_ruc
		clinic_code = dp.clinic_code
		payment_type_document = dp.document_type_code
		payment_document = dp.document_number
		correlative_benefit = '00001'
		correlative = dp.correlative.to_s.rjust(4, '0')
		type_code = dp.type_code
		sunasa_code = dp.sunasa_code
		digemid_code = dp.digemid_code.rjust(6, ' ')
		ean_code = dp.ean_code
		date = dp.date.strftime('%Y%m%d')
		quantity = dp.quantity.to_s.rjust(7,'0')
	 	unitary = ("%.2f" % dp.unitary).rjust(12, '0')
	 	copayment = ("%.2f" % dp.copayment).rjust(12, '0')
	 	amount = ("%.2f" % dp.amount).rjust(12, '0')
	 	amount_not_covered = ("%.2f" % dp.amount_not_covered).rjust(12, '0')
	 	diagnostic = dp.diagnostic_code
	 	exented_code = dp.exented_code
	 	pharm_guide = dp.pharm_guide.rjust(12, '0')
	 	return clinic_ruc+clinic_code+payment_type_document+payment_document+correlative_benefit+correlative+type_code+sunasa_code+digemid_code+ean_code+date+quantity+unitary+copayment+amount+amount_not_covered+diagnostic+exented_code+pharm_guide
	end
end
