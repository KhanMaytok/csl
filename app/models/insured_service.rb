class InsuredService < ActiveRecord::Base
 belongs_to :authorization
 belongs_to :doctor
 belongs_to :clinic_area
 belongs_to :employee

 has_many :purchase_insured_services, dependent: :destroy
 has_one :purchase_coverage_service, dependent: :destroy

 after_create :set_columns

  def set_columns
    if self.has_ticket
      self.ticket_code = get_last_ticket(self.id, 's').to_s.rjust(6, '0')
    end	  	
    self.save
  end


  def factor
    Factor.where(clinic_area: self.clinic_area, insurance: self.authorization.patient.insured.insurance).last.factor
  end

  def get_last_service(id = 0)
    i = InsuredService.where('has_ticket = 1 and id <> '+ id.to_s).order(:id).last
    if i.nil?
      3450
    else
      i.ticket_code.to_i
    end
  end

  def get_last_pharmacy(id = 0)
    i = InsuredPharmacy.where('has_ticket = 1 and id <> '+ id.to_s).order(:id).last
    if i.nil?
      3450
    else
      i.ticket_code.to_i
    end

  end

  def get_last_ticket(id, t)
    case t
    when 's'
      s = get_last_service(id)
      p = get_last_pharmacy
    when 'p'          
      s = get_last_service
      p = get_last_pharmacy(id)
    end
    [s,p].max + 1
  end
end
