class Patient < ActiveRecord::Base
  belongs_to :document_identity_type
  belongs_to :employee

  has_many :authorizations

  has_one :insured
end
