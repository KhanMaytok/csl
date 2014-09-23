class Authorization < ActiveRecord::Base
  belongs_to :patient
  belongs_to :money
  belongs_to :clinic
  belongs_to :status
  belongs_to :doctor
  belongs_to :product
  belongs_to :hospitalization_type
  belongs_to :hospitalization_output_type
end
