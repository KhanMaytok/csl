class PatientsController < ApplicationController
	before_action :block_unloged
  def index
  	if params[:condition].nil?
  		@patients = Patient.order(id: :desc).paginate(:page => params[:page])
  	else
  		if params[:condition] == 'particulares'
  			@patients = Patient.where(is_insured: nil).paginate(:page => params[:page])
  		end  		
  	end 
  end

  def new
    @patients = Patient.all
    @insurances = to_hash(Insurance.order(:name))
    @companies = to_hash(Company.order(:name))
  end

  def create
    Patient.new_patient(params)    
  end

  def show
  end

  def recent
  end
end
