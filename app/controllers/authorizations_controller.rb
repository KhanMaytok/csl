class AuthorizationsController < ApplicationController
    before_action :block_unloged
  def index  	
    if params[:authorization_code].nil? and params[:paternal].nil?
      @authorizations = Authorization.order(date: :desc).paginate(:page => params[:page])
    else
      if params[:paternal].nil?
        @authorizations = Authorization.where(code: params[:authorization_code]).order(date: :desc).paginate(:page => params[:page])  
      else
        @authorizations = Authorization.all.joins(:patient).where('patients.paternal like "'+params[:paternal] +'%"').order(date: :desc).paginate(:page => params[:page])  
      end            
    end
  end

  def recents
  	@authorizations = Authorization.where('year(date) = '+(Time.now.year).to_s+' and month(date) = '+(Time.now.month-1).to_s).order(date: :desc).paginate(:page => params[:page])
  end

  def show
  	@authorization = Authorization.find(params[:id])
  	@statuses = Status.all
  	@doctors = get_doctor_hash(Doctor.all.order(:complet_name))
    @diagnostic_categories = DiagnosticCategory.order(:name)
    @diagnostic_types = get_diagnostic_hash(DiagnosticType.all.order(:name))
    @diagnostic_types_codes = get_diagnostic_code_hash(DiagnosticType.all.order(:id))
    @hospitalization_types = to_hash(HospitalizationType.all)
    @hospitalization_output_types = to_hash(HospitalizationOutputType.all)
    @dni = @authorization.patient.document_identity_code    
    @sub_coverage_types = to_hash(SubCoverageType.all.order(:name))
  end

  def get_doctor_hash(query)
    hash = Hash.new
    query.each do |q|
      hash[q.complet_name] = q.id
    end
    hash
  end

  def get_diagnostic_code_hash(query)
    hash = Hash.new
    query.each do |q|
      hash[q.code.to_s] = q.code
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
