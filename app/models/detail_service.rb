class DetailService < ActiveRecord::Base
  belongs_to :benefit
  belongs_to :clasification_service_type
  belongs_to :sector
  belongs_to :detail_service_group
end
