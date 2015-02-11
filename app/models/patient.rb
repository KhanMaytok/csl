class Patient < ActiveRecord::Base
  belongs_to :document_identity_type
  belongs_to :employee
  validates :sex, :birthday, :name, :paternal, :maternal, :document_identity_code, presence: { message: 'No puede ir en blanco'}
  validate :validate_presence, on: [:create, :save]
  has_many :authorizations, dependent: :destroy

  has_one :insured, dependent: :destroy
  before_create :set_columns

  def set_columns
    self.date_generation = Time.now.strftime('%Y-%m-%d')
    self.clinic_history_code = get_clinic_history_last
  end

  def validate_presence
    if Patient.where(name: name, paternal: paternal, maternal: maternal).exists? or Patient.where(document_identity_code: document_identity_code).exists?
      errors.add(:repeated  , 'El paciente ya existe')      
    end
  end

  def self.new_patient_insured(params, employee_id)
  	p = self.create(phone: params[:phone], document_identity_type_id: 1, document_identity_code: params[:document_identity_code], name: params[:name].upcase, paternal: params[:paternal].upcase, maternal: params[:maternal].upcase, birthday: params[:birthday], age: params[:age], employee_id: employee_id, is_insured: true, sex: params[:sex])
  	c = Company.find(params[:company_id])
  	if params[:afiliation_type_id] == '3'
  		holder_paternal = c.name
  	else
  		holder_paternal = params[:holder_paternal]
  	end
  	i = Insured.create(insurance_id: params[:insurance_id] ,afiliation_type_id: params[:afiliation_type_id], company_id: c.id, patient_id: p.id, code: params[:insured_code], hold_paternal: holder_paternal, hold_maternal: params[:holder_maternal], hold_name: params[:holder_name], relation_ship_id: params[:relation_ship_id], card_number: params[:insured_code], company_name: c.name)
  end

  def self.new_patient_particular(params, employee_id)
    p = self.new(phone: params[:phone], document_identity_type_id: 1, document_identity_code: params[:document_identity_code], name: params[:name].upcase, paternal: params[:paternal].upcase, maternal: params[:maternal].upcase, birthday: params[:birthday], age: params[:age], employee_id: employee_id, is_insured: true, sex: params[:sex])
    return p
  end

  def current_age
    unless self.birthday.nil?
      now = Time.now.utc.to_date
      now.year - self.birthday.year - (self.birthday.to_date.change(:year => now.year) > now ? 1 : 0)
    end
  end

  def insurance_name
    unless self.insured.nil?
      self.insured.insurance.name
    end
  end

  def particular_value
    'X' if self.insured.nil?
  end

  def get_clinic_history_last
    clinic_history_code = Patient.maximum(:clinic_history_code)
    if clinic_history_code.nil? or clinic_history_code.to_i == 0 or clinic_history_code.to_i < 40000 or clinic_history_code == ''
      clinic_history_code = 40001
      return clinic_history_code.to_s
    else
      return (clinic_history_code.to_i + 1).to_s
    end
  end
end
