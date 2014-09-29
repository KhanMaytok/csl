class PayDocument < ActiveRecord::Base
  belongs_to :pay_document_type
  belongs_to :pay_document_group
  belongs_to :sub_mechanism_pay_type
  belongs_to :indicator_global
  belongs_to :authorization

  has_one :benefit

  after_create :set_columns

  def set_columns
  	self.code = "001 - 00".concat((self.id + 52294).to_s)
    a = Authorization.find(self.authorization.id)
    p = a.patient
    d = a.doctor
    c = Clinic.find(1)
    ied = p.insured
    ice = ied.insurance

    self.insurance_code = ice.fact_code
    self.insurance_ruc = ice.ruc
    self.clinic_code = c.code
    self.clinic_ruc = c.ruc
    self.pay_document_type_code = 1
    self.date = a.date.strftime("%Y-%m-%d")
    self.time = a.date.strftime("%H:%M:%S")
    self.quantity = 1
    self.pre_agreed = 0
    self.date_pre_agreed = nil
    self.money_code = a.money.fact_code
    if !a.product.nil?
      self.product_code = a.product.code
    end
    self.note_type_code = 'N'
    self.note_amount = 0
    self.note_code = nil
    self.note_date = nil
    self.reason_code = nil
    self.date_send = nil

  	self.save
  end
end
