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
    	self.initial_amount = (self.quantity * self.unitary).round(2)
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
