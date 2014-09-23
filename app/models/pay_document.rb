class PayDocument < ActiveRecord::Base
  belongs_to :pay_document_type_id
  belongs_to :authorization_id
  belongs_to :sub_mechanism_pay_type_id
  belongs_to :indicator_global_id
  belongs_to :pay_document_group_id
  belongs_to :product_code_id
end
