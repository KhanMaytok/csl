class Diagnostic < ActiveRecord::Base
  belongs_to :authorization
  belongs_to :diagnostic_type
end
