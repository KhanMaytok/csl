class Patient < ActiveRecord::Base
  belongs_to :document_identity_type
  belongs_to :employee

  has_many :authorizations

  has_one :insured

  def new_patient(params)
  	p = self.create(document_identity_type_id: 1, document_identity_code: params[:document_identity_code], name: params[:name].upcase, paternal: params[:paternal].upcase, maternal: params[:maternal].upcase, birthday: params[:birthday], age: params[:age], employee_id: current_employee.id, is_insured: true)
  	c = Company.find(params[:company_id])
  	i = Insured.create(afiliation_type_id: 1, company_id: c.id, patient_id: p.id, code: params[:insured_code], hold_paternal: c.name, hold_maternal: params[:hold_maternal], hold_name: params[:hold_name], relation_ship_id: 6, card_number: params[:insured_code], company_name: c.name)
  end
end
