class AuthorizationsController < ApplicationController
    before_action :block_unloged
  def index
  	@authorizations = Authorization.order(date: :desc).paginate(:page => params[:page])
  end

  def recents
  	@authorizations = Authorization.where('year(date) = '+(Time.now.year).to_s+' and month(date) = '+(Time.now.month-1).to_s).order(date: :desc).paginate(:page => params[:page])
  end

  def show
  	@authorization = Authorization.find(params[:id])
  	@statuses = Status.all
  	@doctors = Doctor.all
    @diagnostic_categories = DiagnosticCategory.order(:name)
    @diagnostic_types = DiagnosticType.where('diagnostic_category_id = ?', DiagnosticCategory.first.id)
  end
  def update_info
  	Authorization.update_info(params)
  	redirect_to show_authorization_path(id: params[:id])
  end

  def update_diagnostic_types
    @diagnostic_types = DiagnosticType.where('diagnostic_category_id = ?', params[:diagnostic_category_id])
    respond_to do |format|
      format.js
    end
  end
end
