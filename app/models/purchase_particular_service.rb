class PurchaseParticularService < ActiveRecord::Base
  belongs_to :particular_service
  belongs_to :service
  belongs_to :service_exented
  belongs_to :diagnostic
end
