class PurchaseInsuredService < ActiveRecord::Base
  belongs_to :insured_service
  belongs_to :service

  before_save :set_columns

  protected
    def set_columns
    	self.initial_amount = self.quantity * (Service.find(self.service_id).unitary.to_f * Factor.where(insurance_id: InsuredService.find(self.insured_service.id).authorization.patient.insured.insurance.id, clinic_area_id: Service.find(self.service_id).clinic_area.id).last.factor)
    	self.copayment = (self.initial_amount * (100 - InsuredService.find(self.insured_service.id).authorization.coverage.cop_var)/100)
    	self.igv = self.copayment * 0.18
    	self.final_amount = self.copayment + self.igv
    end
end
