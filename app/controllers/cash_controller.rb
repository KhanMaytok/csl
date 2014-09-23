class CashController < ApplicationController
  def index
  	if params[:type]
		@services = InsuredService.paginate(:page => params[:page])
	else
		@pharmacies = IPharmacy.paginate(:page => params[:page])
  	end  	
  end

  def recent
  end
end
