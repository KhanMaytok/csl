class PurchaseInsuredService < ActiveRecord::Base
  belongs_to :insured_service
  belongs_to :service
  belongs_to :service_exented

  before_create :set_columns
  before_save :set_columns

  before_destroy :delete_detail_service

  def unitary_factor
    i = self.insured_service.authorization.patient.insured.insurance
    ca = self.insured_service.clinic_area
    f = Factor.where(clinic_area: ca, insurance: i).last.factor.to_f * self.unitary.to_f
  end

  def delete_detail_service
    index = self.id
    if DetailService.where(index: index, purchase_code: 'S').exists?
      d = DetailService.where(index: index, purchase_code: 'S').last
      b = d.benefit
      d.destroy
      b.order_benefit
    end
  end

  protected
  def set_columns
    service_a = Service.find(self.service_id)
    insurance = InsuredService.find(self.insured_service_id).authorization.patient.insured.insurance
    
    #El monto inicial es el unitario multiplicado por la cantidad, multiplicado por el factor
    self.initial_amount = ((self.quantity * self.unitary.to_f) * self.factor.to_f).round(2)        
    
    #El copago variable es el monto inicial por el valor del porcentaje
    self.copayment = (self.initial_amount * (100 - InsuredService.find(self.insured_service.id).authorization.coverage.cop_var.to_f)/100).round(2)

    #Asignando el igv si es que no es exonerado
    if self.service_exented_id == 1
      self.igv = (self.copayment * 0.18).round(2)
    else
      self.igv = 0        
    end     
    self.final_amount = self.copayment + self.igv.round(2)
    unless self.id.nil?
      ds = DetailService.where(purchase_code: 'S', index: self.id)
      if ds.exists?
        detail_service = ds.last
        detail_service.update_data
      end
    end
  end
end
