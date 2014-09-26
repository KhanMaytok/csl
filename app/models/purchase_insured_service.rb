class PurchaseInsuredService < ActiveRecord::Base
  belongs_to :insured_service
  belongs_to :service
  belongs_to :service_exented

  before_save :set_columns

  def unitary_factor
    i = self.insured_service.authorization.patient.insured.insurance
    ca = self.service.clinic_area
    f = Factor.where(clinic_area: ca, insurance: i).last.factor * self.service.unitary
  end

  protected
    def set_columns
    	self.initial_amount = (self.quantity * (Service.find(self.service_id).unitary.to_f * Factor.where(insurance_id: InsuredService.find(self.insured_service.id).authorization.patient.insured.insurance.id, clinic_area_id: Service.find(self.service_id).clinic_area.id).last.factor)).round(2)
    	self.copayment = (self.initial_amount * (100 - InsuredService.find(self.insured_service.id).authorization.coverage.cop_var)/100).round(2)
      if self.service_exented_id == 1
        self.igv = self.copayment * 0.18
      else
        self.igv = 0        
      end    	
    	self.final_amount = self.copayment + self.igv.round(2)
    end
end
