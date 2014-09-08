class WelcomeController < ApplicationController
  def index
  	@procedures = ProcedureType.paginate(:page => params[:page])
  end
end
