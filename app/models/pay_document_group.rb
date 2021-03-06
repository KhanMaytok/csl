class PayDocumentGroup < ActiveRecord::Base
	has_many :pay_documents
	after_create :set_columns

	@@lotes_path = '/home/fabian/facturacion/Lotes/'

	def benefits
		Benefit.joins(:pay_document).where('pay_document_group_id = ?', self.id)
	end

	def set_columns
		if self.code.nil? or self.code == ''
			self.code = (PayDocumentGroup.order(:code).last.code.to_i + 1).to_s.rjust(7,'0')
		end
		
		ruc = Clinic.find(1).ruc
		c_code = Clinic.find(1).code
		date = Time.now.strftime('%Y%m%d')
		self.date = Time.now.strftime('%Y-%m-%d')
		self.name = 'dfac_'+ruc+'_'+c_code+'_'+self.code+'_'+date+'.txt'		
		self.save
	end

	def print
		b = BenefitGroup.create(code: self.code, date: self.date)
		self.benefits.update_all(benefit_group_id: b.id)

		Dir.mkdir @@lotes_path+self.code
		clinic = Clinic.find(1)
		date = Time.now.strftime('%Y%m%d')
		time = Time.now.strftime('%H%M%S')
		File.open(@@lotes_path+self.code+"/"+self.name, 'w') do |f|

			f.puts(get_string_line(self.pay_documents.includes(:pay_document_group, :authorization, :insurance).all, clinic, date, time))
		end
	end

	def get_string_line(query, clinic, date, time)
		string_return = ''
		query.each do |p|
			lot = p.pay_document_group.code.rjust(7, '0')
			insurance_code = p.insurance.code.rjust(5,'X')
			#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
			clinic_ruc = clinic.ruc.to_s.rjust(11,'X')
			clinic_code = clinic.code.to_s.rjust(7,'X')
			document_type = '01'
			#XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
			p.code = p.code.to_s.rjust(12,'0')
			p.save
			document_code = p.code.to_s.rjust(12,'0')
			emission_date = p.emission_date.strftime('%Y%m%d').to_s.rjust(8, 'X')
			product_code = p.product_code.rjust(5,' ')
			if p.insurance_id == 26
				product_code = get_prod_pps(p.authorization.product_code).to_s.ljust(5, 'X')
			end
			quantity = '00001'
			mechanism_code = p.mechanism_code
			sub_mechanism_code = p.sub_mechanism_code
			pre_agreed = "0.00".rjust(12, ' ')
			date_pre_agreed = (" "*8).to_s
			money_code = p.money_code.to_s.rjust(1,'X')
			medicine_exonerated = ("%.2f" % p.amount_medicine_exonerated.to_f).to_s.rjust(12, '0')
			if p.amount_medicine_exonerated.nil?
				medicine_exonerated = "0.00"
			end
			cop_fijo = ("%.2f" % p.total_cop_fijo.to_s).rjust(12,' ')
			cop_var = ("%.2f" % p.total_cop_var.to_s).rjust(12,' ')
			net_amount = ("%.2f" % p.net_amount.to_s).rjust(12,' ')
			igv = ("%.2f" % p.total_igv.to_s).rjust(12,' ')
			total_amount = ("%.2f" % p.total_amount.to_s).rjust(12,' ')
			note_type_code = 'N'
			note_code = (" "*12).to_s
			note_amount = (" "*12).to_s
			note_date = (" "*8).to_s
			reason_code = " ".to_s
			date_send = (" "*8).to_s
			indicator_global_code = 'N'
			string_return = string_return << date+time+lot+insurance_code+clinic_ruc.to_s+clinic_code.to_s+document_type.to_s+document_code.to_s+emission_date+product_code+quantity+mechanism_code+sub_mechanism_code+pre_agreed+date_pre_agreed+money_code+medicine_exonerated+cop_fijo+cop_var+net_amount+igv+total_amount+note_type_code+note_code+note_amount+note_date+reason_code+date_send+indicator_global_code + "\r\n"
		end
		return string_return
	end

	def get_prod_pps(code)
		case code
		when 'ADMI'
			'00028'
		when 'AM05'
			'00001'
		when 'FOLA'
			'00015'
		when 'MINT'
			'00018'
		when 'MNAC'
			'00021'
		when 'MPLN'
			'00022'
		when 'MSLD'
			'00023'
		when 'SEAU'
			'00025'
		when 'SECO'
			'00026'
		end
	end
end
