class Benefit < ActiveRecord::Base
  belongs_to :pay_document
  belongs_to :document_type
  belongs_to :benefit_group

  after_create :set_columns

  has_many :detail_services, dependent: :destroy
  has_many :detail_pharmacies, dependent: :destroy
  has_many :detail_dentals, dependent: :destroy


  def get_code_document(code)
    case code
    when 1
      '01'
    when 2
      '07'
    when 3
      '03' 
    when 5
      '07'
    when 8
      '07'
    end
  end

  def order_benefit
    count = 1
    self.detail_services.each do |d|
      d.correlative = count
      d.save
      count = count + 1
    end

    count = 1
    self.detail_pharmacies.each do |d|
      d.correlative = count
      d.save
      count = count + 1
    end
  end

  def set_columns
    #Help Vars
    a = Authorization.find(self.pay_document.authorization.id)
    p = a.patient
    d = a.doctor
    c = Clinic.find(1)
    ied = p.insured
    ice = ied.insurance

    #Asignations 

    #Cabecera
    self.clinic_ruc = c.ruc
    self.clinic_code = c.code
    self.document_type_id = 0
    self.document_payment_type = get_code_document(a.authorization_type.id)
    self.document_code = self.pay_document.code
  	self.correlative = 1
    #Sobre la prestación
    #Corregir, sólo de momento
  	self.intern_code = self.id + 5550
    #Corregir, sólo de momento
  	self.date = PayDocument.find(self.pay_document_id).authorization.date.strftime("%Y-%m-%d")
  	self.time = PayDocument.find(self.pay_document_id).authorization.date.strftime("%H:%M:%S")    
    
    #Identificación del paciente
    self.afiliation_type_code = ied.afiliation_type.code
    self.insured_code = ied.code
    self.document_identity_type_code = '1'
    self.document_identity_code = p.document_identity_code.ljust(15, ' ')
    self.clinic_history_code = (self.pay_document.authorization.patient.id + 30846).to_s.rjust(8,'0')

    #De las autorizationes
    self.first_authorization_type = get_code_document(a.authorization_type_id)
    self.first_authorization_number = a.code

    #De la prestación
    self.coverage_type_code = a.coverage.sub_coverage_type.coverage_type.code
    self.sub_type_coverage_code = a.coverage.sub_coverage_type.fact_code
    self.first_diagnostic = a.first_diagnostic
    self.second_diagnostic = a.second_diagnostic
    self.third_diagnostic = a.third_diagnostic
    self.date = PayDocument.find(self.pay_document_id).authorization.date.strftime("%Y-%m-%d")
    self.time = PayDocument.find(self.pay_document_id).authorization.date.strftime("%H:%M:%S") 

    #Del profesional
    self.type_professional_code = 'CM'
    self.tuition_code = d.tuition_code
    self.professional_identity_type_code = '1'
    self.professional_identity_code = d.document_identity_code

    #Del paciente que es transferido
    if a.ruc_transference.nil? or a.ruc_transference == ''
      self.ruc_extern_entity = c.ruc      
      self.transference_date = nil
      self.transference_time = nil
    else
      self.ruc_extern_entity = a.ruc_transference      
      self.transference_date = a.date_transference
      self.transference_time = a.time_transference
    end

    #De la prestación de hospitalización
    if a.hospitalization_type.nil?
      self.hospitalization_type_code = " "
      self.hospitalization_output_type_code = " "*2
      self.admission_date = nil
      self.discharge_date = nil
      self.days_hospitalization = nil
    else
      self.hospitalization_type_code = a.hospitalization_type.code
      self.hospitalization_output_type_code = a.hospitalization_output_type.code
      self.admission_date = a.date_intput
      self.discharge_date = a.date_output
      self.days_hospitalization = a.hospitalization_days      
    end
    
    #De la estructura de gasto
    self.cop_fijo = ((self.pay_document.authorization.coverage.cop_fijo)/1.18).round(2)
  	self.save
  end

  def upgrade_data_sales
    self.expense_fee = 0
    self.expense_dental = 0
    self.expense_hotelery = 0
    self.expense_aux_lab = 0
    self.expense_aux_img = 0
    self.expense_other = 0
    self.expense_pharmacy = 0
    self.expense_medicaments_exonerated = 0
    self.detail_services.each do |d|
      case Service.where(code: d.service_code).last.contable_code
        when '1'
          self.expense_fee = self.expense_fee.to_f + d.amount
        when '2'
          self.expense_dental = self.expense_dental.to_f + d.amount
        when '3'
          self.expense_hotelery = self.expense_hotelery.to_f + d.amount
        when '4'            
          self.expense_aux_lab = self.expense_aux_lab.to_f + d.amount
        when '5'
          self.expense_aux_img = self.expense_aux_img.to_f + d.amount
        when '9'
          self.expense_other = self.expense_other.to_f + d.amount
        else
          self.expense_other = self.expense_fee.to_f + d.amount
      end
    end

    self.expense_pharmacy = 0.00
    self.detail_pharmacies.each do |d|
    case d.exented_code
      when 'A'
        self.expense_pharmacy = self.expense_pharmacy.to_f + d.amount
      when 'D'          
        self.expense_medicaments_exonerated = self.expense_medicaments_exonerated.to_f + d.amount
      end
    end

    if self.expense_medicaments_exonerated == nil or self.expense_medicaments_exonerated == '' or self.expense_medicaments_exonerated == 0
      self.expense_medicaments_exonerated = 0.00
    end

    if self.days_hospitalization == nil or self.days_hospitalization == ''
      self.days_hospitalization = 0
    end

    
    percentage = ((100 - self.pay_document.authorization.coverage.cop_var)/100)
    pre_total = self.expense_dental.to_f + self.expense_fee.to_f + self.expense_hotelery.to_f + self.expense_aux_lab.to_f + self.expense_aux_img.to_f + self.expense_pharmacy.to_f + self.expense_medicaments_exonerated.to_f + self.expense_other.to_f
    
    if self.pay_document.has_consultation
      self.cop_var =  ((pre_total - self.pay_document.authorization.patient.insured.insurance.consultation) * percentage).round(2)
      self.cop_fijo = ((self.pay_document.authorization.coverage.cop_fijo)/1.18).round(2)
    else
      if self.first_authorization_type == '1'  or self.first_authorization_type = '01' and self.expense_medicaments_exonerated == 0
        self.cop_var = ((pre_total) * percentage).round(2)
        self.cop_fijo = ((self.pay_document.authorization.coverage.cop_fijo)/1.18).round(2)
      else
        self.cop_var = (pre_total * percentage).round(2)
        self.cop_fijo = 0.00
      end
      
    end

    if self.pay_document.has_consultation.nil? and self.expense_medicaments_exonerated == 0
      self.cop_fijo = ((self.pay_document.authorization.coverage.cop_fijo)/1.18).round(2)
    end
    self.total_expense = pre_total
    

    p = self.pay_document
    p.amount_medicine_exonerated = self.expense_medicaments_exonerated
    if p.amount_medicine_exonerated == nil or p.amount_medicine_exonerated == '' or p.amount_medicine_exonerated == 0
      p.amount_medicine_exonerated = 0.00
    end
    
    if self.expense_medicaments_exonerated != 0 and self.expense_medicaments_exonerated != nil
      p.total_cop_fijo = 0
      p.total_cop_var = self.cop_var
      p.net_amount = (self.total_expense - (p.total_cop_var + p.total_cop_fijo)).round(2)
      p.total_igv = (0).round(2)
    else
      p.total_cop_fijo = self.cop_fijo
      p.total_cop_var = self.cop_var
      p.net_amount = (self.total_expense - (p.total_cop_var + p.total_cop_fijo))
      p.total_igv = ((p.net_amount.to_f) * 0.18).round(2)
    end
    p.total_amount = (p.net_amount.to_f + p.total_igv.to_f).to_f
    p.is_closed = true
    self.save
    p.save
  end
end
