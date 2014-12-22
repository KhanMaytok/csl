class PurchaseInsuredPharmacy < ActiveRecord::Base
  belongs_to :product_pharm_type
  belongs_to :insured_pharmacy
  belongs_to :cum_sunasa_product
  belongs_to :digemid_product
  belongs_to :ean_product
  belongs_to :product_pharm_exented

  before_save :set_columns

  protected
    def set_columns
      self.without_igv = ((self.quantity * self.unitary).round(2)/1.18).round(2)
      if self.insured_pharmacy.authorization.patient.insured.insurance_id == 3
        porc = 20
      else
        porc = 10
      end
      self.first_copayment = (self.without_igv * (porc.to_f)/100).round(2)
    	self.initial_amount = (self.without_igv -  self.first_copayment).round(2)
    	self.copayment = (self.initial_amount * (100 - InsuredPharmacy.find(self.insured_pharmacy.id).authorization.coverage.cop_var)/100).round(2)
    	if self.product_pharm_exented_id == 1
        self.igv = (self.copayment * 0.18).round(2)
      else
        self.igv = 0
      end
      self.ean_product_id = 0
      self.cum_sunasa_product_id = 0
    	self.final_amount = (self.copayment + self.igv).round(2)
    end
end
