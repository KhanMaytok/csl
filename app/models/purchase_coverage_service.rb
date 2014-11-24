class PurchaseCoverageService < ActiveRecord::Base
  belongs_to :insured_service
  belongs_to :service
end
