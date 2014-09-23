class PurchaseInsuredPharmacy < ActiveRecord::Base
  belongs_to :product_pharm_type
  belongs_to :insured_pharmacy
  belongs_to :cum_sunasa_product
  belongs_to :digemid_product
  belongs_to :ean_product
  belongs_to :product_pharm_exented
end
