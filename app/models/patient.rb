class Patient < ActiveRecord::Base
  belongs_to :document_identity_type
  belongs_to :employee
end
