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
  	@doctors = get_doctor_hash(Doctor.all)
    @diagnostic_categories = DiagnosticCategory.order(:name)
    @diagnostic_types = get_diagnostic_hash(DiagnosticType.all.order(:name))
    @hospitalization_types = to_hash(HospitalizationType.all)
    @hospitalization_output_types = to_hash(HospitalizationOutputType.all)    
  end

  def get_doctor_hash(query)
    hash = Hash.new
    query.each do |q|
      hash[q.complet_name] = q.id
    end
    hash
  end

  def get_diagnostic_hash(query)
    hash = Hash.new
    query.each do |q|
      hash[q.name.to_s[0,50] + '... '+ q.code.to_s] = q.code
    end
    hash
  end

  def update_info
  	Authorization.update_info(params)
  	redirect_to show_authorization_path(id: params[:id])
  end

end
