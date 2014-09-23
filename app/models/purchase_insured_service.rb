class PurchaseInsuredService < ActiveRecord::Base
  belongs_to :insured_service
  belongs_to :service
end
