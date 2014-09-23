class PurchaseInsuredService < ActiveRecord::Base
  belongs_to :insured_service
  belongs_to :service

  before_save :set_columns

  def.sel

  protected
    def set_columns
    	self.initial_amount = self.quantity * Service.find(self.service_id).unitary
    	self.cop_var = (self.init_amount * (100 - IService.find(self.i_service.id).authorization.cop_var)/100)
    	self.igv = self.cop_var * 0.18
    	self.final_amount = self.cop_var + self.igv
    end
end
