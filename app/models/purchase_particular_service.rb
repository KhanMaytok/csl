class PurchaseParticularService < ActiveRecord::Base
  belongs_to :particular_service
  belongs_to :service
  belongs_to :service_exented
  belongs_to :diagnostic

  before_save :set_columns

	def set_columns

	    #El monto inicial es el unitario multiplicado por la cantidad, multiplicado por el factor
	    self.initial_amount = ((self.quantity * self.unitary.to_f)).round(2)        
	    
	    #El copago variable es el monto inicial por el valor del porcentaje
	    self.copayment = self.initial_amount

	    self.igv = (self.copayment * 0.18).round(2)
	    self.final_amount = self.copayment + self.igv.round(2)
	end
end
