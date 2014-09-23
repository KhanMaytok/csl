class Benefit < ActiveRecord::Base
  belongs_to :pay_document
  belongs_to :document_type
  belongs_to :benefit_group
end
