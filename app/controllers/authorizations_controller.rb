class AuthorizationsController < ApplicationController
  def index
  	@authorizations = Authorization.order(date: :desc).paginate(:page => params[:page])
  end

  def recents
  	@authorizations = Authorization.where('year(date) = '+(Time.now.year).to_s+' and month(date) = '+(Time.now.month-1).to_s).order(date: :desc).paginate(:page => params[:page])
  end

  def show
  end
end
