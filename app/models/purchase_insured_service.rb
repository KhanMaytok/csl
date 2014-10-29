class PurchaseInsuredService < ActiveRecord::Base
  belongs_to :insured_service
  belongs_to :service
  belongs_to :service_exented

  before_create :set_columns

  def unitary_factor
    i = self.insured_service.authorization.patient.insured.insurance
    ca = self.service.clinic_area
    if self.service.unitary.nil?
      f = Factor.where(clinic_area: ca, insurance: i).last.factor * self.unitary
    else
      f = Factor.where(clinic_area: ca, insurance: i).last.factor * self.service.unitary
    end
    
  end

  protected
    def set_columns
      service_a = Service.find(self.service_id)
      insurance = InsuredService.find(self.insured_service_id).authorization.patient.insured.insurance
      if self.unitary.nil?

        if service_a.clinic_area_id == 7 and (insurance.id == 3 or insurance.id == 8 or insurance.id == 10 or insurance.id == 13)
          self.initial_amount = (self.quantity * (Service.find(self.service_id).unitary.to_f * Factor.where(insurance_id: InsuredService.find(self.insured_service.id).authorization.patient.insured.insurance.id, clinic_area_id: Service.find(self.service_id).clinic_area.id).last.factor) + 70).round(2)
        else
          self.initial_amount = (self.quantity * (Service.find(self.service_id).unitary.to_f * Factor.where(insurance_id: InsuredService.find(self.insured_service.id).authorization.patient.insured.insurance.id, clinic_area_id: Service.find(self.service_id).clinic_area.id).last.factor)).round(2)
        end
        self.copayment = (self.initial_amount * (100 - InsuredService.find(self.insured_service.id).authorization.coverage.cop_var)/100).round(2)
        if self.service_exented_id == 1
          self.igv = (self.copayment * 0.18).round(2)
        else
          self.igv = 0        
        end
        self.final_amount = self.copayment + self.igv.round(2)
      else
        self.initial_amount = (self.quantity * self.unitary).round(2)
        self.copayment = self.initial_amount
        if self.service_exented_id == 1
          self.igv = (self.copayment * 0.18).round(2)
        else
          self.igv = 0        
        end     
        self.final_amount = self.copayment + self.igv.round(2)
      end
    	
    end
end
