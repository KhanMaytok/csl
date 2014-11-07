class PayDocument < ActiveRecord::Base
  belongs_to :pay_document_type
  belongs_to :pay_document_group
  belongs_to :sub_mechanism_pay_type
  belongs_to :indicator_global
  belongs_to :authorization

  has_one :benefit, dependent: :destroy

  after_create :set_columns

  before_create :set_code

  def set_code
    self.code = "0001-0000000"
  end  
  
  def set_columns
    #Help Vars
    a = Authorization.find(self.authorization.id)
    p = a.patient
    d = a.doctor
    c = Clinic.find(1)
    ied = p.insured
    ice = ied.insurance
    #Ruc administradora : 20534823500
    
    #Asignations    
    self.emission_date = Time.now.strftime("%Y-%m-%d")
    self.insurance_code = ice.fact_code
    self.mechanism_code = '01'
    self.sub_mechanism_code = '999'
    self.insurance_ruc = ice.ruc
    self.clinic_code = c.code
    self.clinic_ruc = c.ruc
    self.pay_document_type_code = '01'
    self.pay_document_type_id = 1
    self.quantity = 1
    self.pre_agreed = 0
    self.date_pre_agreed = nil
    self.money_code = a.money.fact_code
    if a.product.nil?
      self.product_code = '99999'
    else
      self.product_code = a.product.code
    end
    self.note_type_code = 'N'
    self.note_code = " "*12
    self.note_amount = 0
    self.note_date = nil
    self.reason_code = " "
    self.date_send = nil
    unless a.hospitalization_type.nil?
      self.hospitalization_type_code = a.hospitalization_type.code
      self.hospitalization_output_type_code = a.hospitalization_output_type.code
      self.admission_date = a.date_intput
      self.discharge_date = a.date_output
      self.days_hospitalization = a.hospitalization_days
    end    
  	self.save
  end

  def get_last_facture
    if !PayDocument.all.exists?
      s = 50450
    else
      s = PayDocument.order(:id).last.code[5,7].to_i
    end
      (s + 1).to_s
  end
end
