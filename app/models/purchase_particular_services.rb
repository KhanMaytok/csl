class PurchaseParticularServices < ActiveRecord::Base
  belongs_to :insured_service
  belongs_to :service
  belongs_to :service_exented
  belongs_to :diagnostic
end
