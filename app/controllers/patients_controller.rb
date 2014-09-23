class PatientsController < ApplicationController
	before_action :block_unloged
  def index
  	if params[:condition].nil?
  		@patients = Patient.paginate(:page => params[:page])
  	else
  		if params[:condition] == 'particulares'
  			@patients = Patient.joins(:insured).paginate(:page => params[:page])
  		end  		
  	end 
  end

  def show
  end

  def recent
  end
end
