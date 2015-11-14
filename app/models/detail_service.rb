class DetailService < ActiveRecord::Base
  belongs_to :benefit
  belongs_to :clasification_service_type
  belongs_to :sector
  belongs_to :detail_service_group
  belongs_to :service

  before_create :set_columns

  def update_data
  	p = PurchaseInsuredService.where(id: self.index)
  	if p.exists?
  		purchase_insured_service = p.last
  		self.unitary = purchase_insured_service.initial_amount / purchase_insured_service.quantity
      self.quantity = purchase_insured_service.quantity
      self.copayment = purchase_insured_service.copayment
      self.amount = (self.unitary * self.quantity).round(2)
      self.save
    end
  end

  def purchase_insured_service
    PurchaseInsuredService.find(self.index)
  end

  def pay_document
    PayDocument.joins(benefit: :detail_services).where("detail_services.id = ?", self.id).last
  end

  def set_columns
    if self.manual
      puts self.quantity
      puts self.unitary
      puts self.factor
      self.amount = self.quantity * self.unitary * self.factor
    end
  end
end
