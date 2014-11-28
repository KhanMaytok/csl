class AdmissionsController < ApplicationController
  def new
  	@authorization_types = to_hash(AuthorizationType.all)
  end

  def ready
  end

  def index
  end

  def confirm    
    if Authorization.maximum(:intern_code).nil? or Authorization.maximum(:intern_code) == 0 or Authorization.maximum(:intern_code) == '' or Authorization.maximum(:intern_code).to_i < 5000
      intern_code = 15001
    else
      intern_code = Authorization.maximum(:intern_code).to_i + 1
    end
    if params[:authorization_type_id] == '7'
      
    else

    end
  	a = Authorization.create(intern_code: intern_code.to_s, clinic_id: 1, money_id: 2, code: params[:code], authorization_type_id: params[:authorization_type_id], patient_id: params[:patient_id], date: Time.now)
  	redirect_to authorizations_path(page: 1)
  end

end
