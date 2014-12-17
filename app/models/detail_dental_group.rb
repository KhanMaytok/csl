class DetailDentalGroup < ActiveRecord::Base
	has_many :detail_dentals
	after_create :set_columns

	def set_columns
		ruc = Clinic.find(1).ruc
		code = Clinic.find(1).code
		self.name = 'dden_'+ruc+'_'+code+'_'+self.code+'_'+self.date.strftime('%Y%m%d')+'.txt'
		self.save
	end

	def print
=begin
		File.open("/home/and/Desktop/andpc/tedef/"+self.code+"/"+self.name, 'w') do |f|
			f.puts (get_line(self.detail_pharmacies.all))
		end
=end
		File.open("/home/and/Desktop/facturacion/Lotes/"+self.code+"/"+self.name, 'w') do |f| 
			if self.detail_dentals.exists?
				f.puts (get_line(self.detail_dentals.all))
			end			
		end
	end

	def get_line(dd)
		string_return = ''
		self.detail_dentals.each do |dd|
			ipress_ruc = dd.ipress_ruc.ljust(11, 'X')
			ipress_code = dd.ipress_code.ljust(7, 'X')
			document_payment_type = dd.document_payment_type.ljust(2, 'X')
			document_payment_code = dd.document_payment_code.ljust(12, 'X')
			correlative = dd.correlative.to_s.rjust(5, '0')			
			correlative_dental = dd.correlative_dental.to_s.rjust(4, '0')
			dental_code = dd.dental_code.ljust(2, 'X')
			mesial = dd.mesial.ljust(1, 'X')
			lingual = dd.lingual.ljust(1, 'X')
			distal = dd.distal.ljust(1, 'X')
			vestibular = dd.vestibular.ljust(1, 'X')
			oclusal = dd.oclusal.ljust(1, 'X')
			all_piece = dd.all_piece.ljust(1, 'X')
			palatina = dd.palatina.ljust(1, 'X')
			cervical = dd.cervical.ljust(1, 'X')
			incisal = dd.incisal.ljust(1, 'X')
		 	string_return = string_return << ipress_ruc + ipress_code+ document_payment_type + document_payment_code + correlative + correlative_dental + dental_code + mesial + lingual + distal + vestibular + oclusal + all_piece + palatina + cervical + incisal + "\r\n"
		end
		return string_return
	end
end
