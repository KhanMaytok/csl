class Benefit < ActiveRecord::Base
  belongs_to :pay_document
  belongs_to :document_type
  belongs_to :benefit_group

  after_create :set_columns

  has_many :detail_services
  has_many :detail_pharmacies

  def set_columns

    a = Authorization.find(self.pay_document.authorization.id)
    p = a.patient
    doctor = a.doctor
    c = Clinic.find(1)
    ied = p.insured
    ice = ied.insurance

  	self.correlative = 1
  	self.cod_benefit_intern = self.id + 5550
  	self.date = PayDocument.find(self.pay_document_id).authorization.date.strftime("%Y-%m-%d")
  	self.time = PayDocument.find(self.pay_document_id).authorization.date.strftime("%H:%M:%S")

    self.insurance_ruc = c.ruc
    self.insurance_code = c.code
    self.document_type
    self.intern_code = self.cod_benefit_intern
    self.afiliation_type_code = ied.afiliation_type.code
    self.insured_code = ied.code
    self.document_identity_type_code = '1'
    self.document_identity_code = p.document_identity_code
    self.clinic_history_code = p.clinic_history
    self.first_document_type_code = a.code
    self.first_authorization_type = '1'
    self.first_authorization_number = a.code
    self.coverage_type_code = a.coverage.sub_coverage_type.coverage_type.code
    self.sub_type_coverage_code = a.coverage.sub_coverage_type.code
    self.first_diagnostic = a.diagnostics.where(correlative: 1, authorization_id: a.id).last.diagnostic_type.code
    if a.diagnostics.where(correlative: 2, authorization_id: a.id).exists?
      self.second_diagnostic = a.diagnostics.where(correlative: 2, authorization_id: a.id).last.diagnostic_type.code
    end
    if a.diagnostics.where(correlative: 3, authorization_id: a.id).exists?
      self.third_diagnostic = a.diagnostics.where(correlative: 3, authorization_id: a.id).last.diagnostic_type.code
    end
    self.type_professional_code = 'CM'
    self.tuition_code = doctor.tuition_code
    self.professional_identity_type_code =  '1'
    self.professional_identity_code = doctor.document_identity_code
    self.ruc_extern_entity = c.ruc
    self.transference_date = nil
    self.transference_time = nil

    self.hospitalization_type_code = nil
    self.hospitalization_output_type_code = nil
    self.admission_date = nil
    self.discharge_date = nil
    self.days_hospitalization = nil
    self.cop_fijo = (self.pay_document.authorization.coverage.cop_fijo)/1.18
  	self.save
  end

  def update_sales
    self.detail_services.each do |d|
      case d.sector_id
      when 2
        self.expense_fee = self.expense_fee.to_f + d.amount
      when 3
        self.expense_hotelery = self.expense_hotelery.to_f + d.amount
      when 4
        self.expense_aux_lab = self.expense_aux_lab.to_f + d.amount
      when 6
        self.expense_aux_img = self.expense_aux_img.to_f + d.amount
      when 10         
        self.expense_aux_img = self.expense_aux_img.to_f + d.amount
      end
    end

    self.detail_pharmacies.each do |d|
      case d.exented_code
      when 'A'
        self.expense_pharmacy = self.expense_pharmacy.to_f + d.amount
      when 'D'          
        self.expense_medicaments_exonerated = self.expense_medicaments_exonerated.to_f + d.amount
      end
    end

    self.cop_fijo = ((self.pay_document.authorization.coverage.cop_fijo)/1.18).round(2)
    percentage = (100 - self.pay_document.authorization.coverage.cop_var)/100
    self.total_expense = self.expense_fee.to_f + self.expense_hotelery.to_f + self.expense_aux_lab.to_f + self.expense_aux_img.to_f + self.expense_pharmacy.to_f + self.expense_medicaments_exonerated.to_f
    self.cop_var = (self.total_expense) * percentage

    self.save

    p = self.pay_document
    p.amount_medicine_exonerated = self.expense_medicaments_exonerated
    p.total_cop_fijo = self.cop_fijo
    p.total_cop_var = self.cop_var
    p.net_amount = self.total_expense - (p.total_cop_var + p.total_cop_fijo)
    p.total_igv = p.net_amount * 0.18
    p.total_amount = p.net_amount + p.total_igv
    p.is_closed = true
    p.save
  end
end
