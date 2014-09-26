class Benefit < ActiveRecord::Base
  belongs_to :pay_document
  belongs_to :document_type
  belongs_to :benefit_group

  after_create :set_columns

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
    
  	self.save
  end
end
