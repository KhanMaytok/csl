class FacturationsController < ApplicationController
  def index
  	@authorizations = Authorization.order(date: :desc).paginate(:page => params[:page])
  end

  def new
  	@authorization = Authorization.find(params[:authorization_id])
  	@insured = Insured.find(params[:insured_id])
  end
  def ready
  	
  end
  def confirm
  	
  end

  def show
  end
end
