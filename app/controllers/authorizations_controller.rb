class AuthorizationsController < ApplicationController
    respond_to :html, :js
    before_action :block_unloged
    before_action :set_authorization, only: [:show, :clear_data]

  def index  	
    if params[:authorization_code].nil? and params[:paternal].nil?
      @authorizations = Authorization.order('convert(intern_code, decimal) DESC').paginate(:page => params[:page])
    else
      if params[:paternal].nil?
        @authorizations = Authorization.where('code like "%'+ params[:authorization_code] + '%"').order('convert(intern_code, decimal) DESC').paginate(:page => params[:page])  
      else
        @authorizations = Authorization.all.joins(:patient).where('patients.paternal like "%'+params[:paternal] +'%" and patients.maternal like "%'+params[:maternal] +'%"').order('convert(intern_code, decimal) DESC').paginate(:page => params[:page])  
      end            
    end
    @statuses = to_hash(Status.all)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def export
    @authorizations = Authorization.where('date(date) = "'+params[:date]+'"').order(:date)
  end
  
  def show
  	@statuses = Status.all
  	@doctors = get_doctor_hash(Doctor.all.order(:complet_name))
    @diagnostic_categories = DiagnosticCategory.order(:name)
    @diagnostic_types = get_diagnostic_hash(DiagnosticType.all.order(:name))
    @diagnostic_types_codes = get_diagnostic_code_hash(DiagnosticType.all.order(:id))
    @hospitalization_types = to_hash(HospitalizationType.all)
    @hospitalization_output_types = to_hash(HospitalizationOutputType.all)
    @dni = @authorization.patient.document_identity_code    
    @sub_coverage_types = get_subcoverage_hash(SubCoverageType.all.order(:name))

    @my_date = @authorization.date + 5.hours
    unless @authorization.coverage.nil? 
      unless @authorization.coverage.sub_coverage_type.nil?
        unless @authorization.coverage.sub_coverage_type.coverage_type.nil?
          if @authorization.coverage.sub_coverage_type.coverage_type.id == 7
            @d = @authorization.date.strftime("%A").to_s
            @j = @authorization.date.strftime("%H:%M:%S")
            @h = @authorization.date.strftime("%H").to_i
            @m = @authorization.date.strftime("%M").to_i
            if @h > 19  || @h < 8 || @d=="Sunday" || (@h > 14 and @d== "Saturday")
              @error="cobrar el recargo"
            end
          end
        end
      end      
    end
  end
  
  def set_status
    @authorization = Authorization.find(params[:authorization_id])
    @authorization.status_id = params[:status_id]
    @authorization.save
    @authorizations = Authorization.order('convert(intern_code, decimal) DESC').paginate(:page => params[:page])
    @statuses = to_hash(Status.all)
    respond_to do |format|
      format.js
    end
  end

  def update_info
  	Authorization.update_info(params)
    @authorization = Authorization.find(params[:id])
    respond_to do |format|
      format.js
      format.html{redirect_to show_authorization_path(id: params[:id])}
    end
  end

  def update_diagnostics
    if params[:first_diagnostic_id].nil? or params[:first_diagnostic_id] == ""
      @first_diagnostic = nil
    else
      @first_diagnostic = DiagnosticType.find_by_code(params[:first_diagnostic_id]).code
    end

    if params[:second_diagnostic_id].nil? or params[:second_diagnostic_id] == ""
      @second_diagnostic = nil
    else
      @second_diagnostic = DiagnosticType.find_by_code(params[:second_diagnostic_id]).code
    end

    if params[:third_diagnostic_id].nil? or params[:third_diagnostic_id] == ""
      @third_diagnostic = nil
    else
    @third_diagnostic = DiagnosticType.find_by_code(params[:third_diagnostic_id]).code
    end    
    respond_to do |format|
      format.js
    end
  end

  def destroy
    a = Authorization.find(params[:authorization_id])
    a.destroy
    redirect_to authorizations_path(page: '1')
  end

  def clear_data
    @authorization.doctor_id = nil
    @authorization.first_diagnostic = nil
    @authorization.second_diagnostic = nil
    @authorization.third_diagnostic = nil
    @authorization.has_consultation = nil
    @authorization.save
    @authorization.insured_services.each do |i|
      i.destroy
    end
    @authorization.insured_pharmacies.each do |i|
      if i.pharm_type_sale_id == 1
        i.destroy
      end
    end
    @authorization.pay_documents.each do |p|
      p.destroy
    end
    respond_to do |format|
      format.html { redirect_to show_authorization_path(id: @authorization.id) }
      format.js
    end
  end

  def load
    @patients = Patient.where(paternal: params[:paternal], maternal: params[:maternal])
    @authorization = Authorization.find(params[:authorization_id])
    respond_to do |format|
      format.html { redirect_to show_authorization_path(id: @authorization.id) }
      format.js
    end
  end

  def fix
    @authorization = Authorization.find(params[:authorization_id])
    patient = Patient.find(params[:patient_id])
    @authorization.patient = patient
    @authorization.save
    @authorizations = Authorization.order('convert(intern_code, decimal) DESC').paginate(:page => params[:page])
    respond_to do |format|
      format.html { redirect_to show_authorization_path(id: @authorization.id) }
      format.js
    end
  end

  def update_intern_code
    authorization = Authorization.find(params[:authorization_id])
    authorization.intern_code = params[:intern_code]
    authorization.save
    @authorizations = Authorization.order('convert(intern_code, decimal) DESC').paginate(:page => params[:page])
    @statuses = to_hash(Status.all)
    respond_to do |format|
      format.html { redirect_to show_authorization_path(id: @authorization.id) }
      format.js
    end
  end

  private

  def get_doctor_hash(query)
    hash = Hash.new
    query.each do |q|
      hash[q.complet_name] = q.id
    end
    hash
  end

  def get_subcoverage_hash(query)
    hash = Hash.new
    query.each do |q|
      hash[q.name + " - " + q.code + " - " + q.other_code] = q.id
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

  def set_authorization    
    @authorization = Authorization.find(params[:id])
  end

end

