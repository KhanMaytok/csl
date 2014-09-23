class DetailPharmacy < ActiveRecord::Base
  belongs_to :benefit
  belongs_to :detail_pharmacy_group
end
