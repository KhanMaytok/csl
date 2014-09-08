class InsuredsController < ApplicationController
  def index
  	if params[:paternal].nil?
  		@insureds = Insured.paginate(:page => params[:page])
  	else
  		@insureds = Insured.where("paternal like '%"+params[:paternal]+"%'").paginate(:page => params[:page])
  	end  	
  end

  def show
  	@insured = Insured.find(params[:id])
  end

  def insert_dni
  	@insured = Insured.find(params[:id])
  end

  def create_dni
  	if request.post?
  		insured = Insured.find(params[:id])
  		insured.dni = params[:dni]
  		insured.save
  		redirect_to show_insured_path(id: params[:id])
  	end
  end
end
