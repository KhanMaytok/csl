class Benefit < ActiveRecord::Base
  belongs_to :pay_document
  belongs_to :document_type
  belongs_to :benefit_group

  after_create :set_columns

  def set_columns
  	self.correlative = 1
  	self.cod_benefit_intern = self.id + 5550
  	self.date = PayDocument.find(self.pay_document_id).authorization.date.strftime("%Y-%m-%d")
  	self.time = PayDocument.find(self.pay_document_id).authorization.date.strftime("%H-%M-%S")
  	self.save
  end
end
