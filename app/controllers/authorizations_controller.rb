class AuthorizationsController < ApplicationController
    respond_to :html, :js
    before_action :block_unloged
  def index  	
    if params[:authorization_code].nil? and params[:paternal].nil?
      @authorizations = Authorization.order(date: :desc).paginate(:page => params[:page])
    else
      if params[:paternal].nil?
        @authorizations = Authorization.where('code like "%'+ params[:authorization_code] + '%"').order(date: :desc).paginate(:page => params[:page])  
      else
        @authorizations = Authorization.all.joins(:patient).where('patients.paternal like "%'+params[:paternal] +'%" and patients.maternal like "%'+params[:maternal] +'%"').order(date: :desc).paginate(:page => params[:page])  
      end            
    end
    respond_to do |format|
      format.js
      format.html
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
    @au=Authorization.find(params[:id]).date
    @error=false
    if @au.strftime("%Y") == 2014   
        redirect_to :controller=>"authorization",:action=>"show"
      else
        @error=true
    end

    end

  def print_excel
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Examples") do |sheet|
        sheet.add_row ["Código", "Paciente", "Aseguradora"]
        Authorization.all.each do |a|
          if a.patient.nil?
            sheet.add_row [a.code, '0', '0']
          else
            sheet.add_row [a.code, to_name_i(a.patient), a.patient.insured.insurance.name]
          end          
        end
      end
      p.serialize('c:/prueba/tedef/simple.xlsx')
    end
    redirect_to authorizations_path
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

end
