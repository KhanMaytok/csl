class Provider < ActiveRecord::Base
  belongs_to :provider_type
  belongs_to :clinic_area
  belongs_to :doctor
  has_many :detail_services
  has_many :detail_pharmacies
end
