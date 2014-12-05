class DetailDental < ActiveRecord::Base
	belongs_to :benefit

	before_create :set_columns

	def set_columns
		c = Clinic.first
		b = Benefit.find(self.benefit_id)
		self.ipress_ruc = c.ruc
		self.ipress_code = c.code
		self.document_payment_type = '01'
		self.document_payment_code = b.pay_document.code
		self.correlative = '1'
		if b.detail_dentals.exists?
			self.correlative_dental = self.get_correlative
		else
			self.correlative_dental = '1'
		end
	end

	def get_correlative
		(self.benefit.detail_dentals.count + 1).to_s
	end

	def get_code
		mesial.to_s + lingual.to_s + distal.to_s + vestibular.to_s + oclusal.to_s + all_piece.to_s + palatina.to_s + cervical.to_s + incisal.to_s
	end
end
