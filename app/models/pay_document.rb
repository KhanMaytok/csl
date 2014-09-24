class PayDocument < ActiveRecord::Base
  belongs_to :pay_document_type
  belongs_to :pay_document_group
  belongs_to :sub_mechanism_pay_type
  belongs_to :indicator_global
  belongs_to :authorization

  has_one :benefit

  after_create :set_columns

  def set_columns
  	self.code = "001 - 00".concat((self.id + 52294).to_s)
  	self.save
  end
end
