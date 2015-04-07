class PayDocument < ActiveRecord::Base
  belongs_to :pay_document_type
  belongs_to :pay_document_group
  belongs_to :sub_mechanism_pay_type
  belongs_to :indicator_global
  belongs_to :authorization
  belongs_to :employee

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

  def liquidation_string
    liquidations = Array.new
    self.benefit.detail_pharmacies.each do |d|
      if PurchaseInsuredPharmacy.where(id: d.index).exists?
        pu = PurchaseInsuredPharmacy.find(d.index)
        unless liquidations.include?(pu.insured_pharmacy.liquidation)
          liquidations.push(pu.insured_pharmacy.liquidation) 
        end                 
      end
    end
    pretty_array(liquidations)
  end

  def set_code_to_details
    b = self.benefit
    b.document_code = self.code
    b.save
    b.detail_services.each do |ds|
      ds.payment_document = self.code
      ds.save
    end
    b.detail_pharmacies.each do |dp|
      dp.document_number = self.code
      dp.save
    end
    b.detail_dentals.each do |dd|
      dd.document_payment_code = self.code
      dd.save
    end
  end

  def liquidation_array
    liquidations = Array.new
    self.benefit.detail_pharmacies.each do |d|
      if PurchaseInsuredPharmacy.where(id: d.index).exists?
        pu = PurchaseInsuredPharmacy.find(d.index)
        unless liquidations.include?(pu.insured_pharmacy.liquidation)
          liquidations.push(pu.insured_pharmacy.liquidation) 
        end                 
      end
    end
    liquidations
  end

  def pretty_array a
    s = ''
    a.each do |e|
      s += e.to_s + ' - '
    end
    s
  end
end
