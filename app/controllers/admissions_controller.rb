class AdmissionsController < ApplicationController
  def new
  	@authorization_types = to_hash(AuthorizationType.all)
  end

  def ready
  end

  def index
  end

  def confirm
  	a = Authorization.create(money_id: 2, code: params[:code], authorization_type_id: params[:authorization_type_id], patient_id: params[:patient_id], date: Time.now)
  	redirect_to ready_admission_path(a.id)
  end
end
