class Patient < ActiveRecord::Base
  belongs_to :document_identity_type
  belongs_to :employee

  has_many :authorizations, dependent: :destroy

  has_one :insured, dependent: :destroy

  def self.new_patient(params, employee_id)
  	p = self.create(document_identity_type_id: 1, document_identity_code: params[:document_identity_code], name: params[:name].upcase, paternal: params[:paternal].upcase, maternal: params[:maternal].upcase, birthday: params[:birthday], age: params[:age], employee_id: employee_id, is_insured: true, sex: params[:sex])
  	c = Company.find(params[:company_id])
  	if params[:afiliation_type_id] == '3'
  		holder_paternal = c.name
  	else
  		holder_paternal = params[:holder_paternal]
  	end
  	i = Insured.create(insurance_id: params[:insurance_id] ,afiliation_type_id: params[:afiliation_type_id], company_id: c.id, patient_id: p.id, code: params[:insured_code], hold_paternal: holder_paternal, hold_maternal: params[:holder_maternal], hold_name: params[:holder_name], relation_ship_id: params[:relation_ship_id], card_number: params[:insured_code], company_name: c.name)
  end
end
