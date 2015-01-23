class DetailService < ActiveRecord::Base
  belongs_to :benefit
  belongs_to :clasification_service_type
  belongs_to :sector
  belongs_to :detail_service_group

  def update_data
  	p = PurchaseInsuredService.where(id: self.index)
  	if p.exists?
  		purchase_insured_service = p.last
  		self.unitary = purchase_insured_service.unitary_factor
	    self.quantity = purchase_insured_service.quantity
	    self.copayment = purchase_insured_service.copayment
	    self.amount = (self.unitary * self.quantity).round(2)
	    self.save
  	end
  end
end
