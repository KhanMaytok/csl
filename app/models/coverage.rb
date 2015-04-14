class Coverage < ActiveRecord::Base
  belongs_to :authorization
  belongs_to :sub_coverage_type
end
