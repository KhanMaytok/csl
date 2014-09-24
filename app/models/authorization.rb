class Authorization < ActiveRecord::Base
  belongs_to :patient
  belongs_to :money
  belongs_to :clinic
  belongs_to :status
  belongs_to :doctor
  belongs_to :product
  belongs_to :hospitalization_type
  belongs_to :hospitalization_output_type

  has_one :coverage

  has_many :insured_services
  has_many :insured_pharmacies
  has_many :pay_documents
end
