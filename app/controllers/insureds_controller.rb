class InsuredsController < ApplicationController
  before_action :block_unloged
  def index
  	if params[:paternal].nil?
  		@insureds = Insured.paginate(:page => params[:page])
  	else
  		@insureds = Insured.joins(:patient).where("paternal like '%"+params[:paternal]+"%'").paginate(:page => params[:page])
  	end  	
  end

  def show
  	@insured = Insured.find(params[:id])
  end

  def update
    @insured = Insured.find(params[:insured_id])
    @insured.update(code: params[:code], hold_name: params[:hold_name], hold_paternal: params[:hold_paternal], hold_maternal: params[:hold_maternal], relation_ship_id: params[:relation_ship_id], insurance_id: params[:insurance_id], company_id: params[:company_id])
    redirect_to show_patient_path(id: @insured.patient.id)
  end
end
