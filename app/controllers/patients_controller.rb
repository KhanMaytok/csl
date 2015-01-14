class PatientsController < ApplicationController
  respond_to :html, :js, :json
	before_action :block_unloged
  before_action :set_patient, only: [:update_other, :update_dni, :update_phone, :update_representative]
  def index
    @patients = Patient.order(id: :desc).paginate(:page => params[:page])
    unless params[:paternal].nil?
      @patients = Patient.where('paternal like "%'+params[:paternal]+'%" and maternal like "%'+params[:maternal]+'%"') .order(id: :desc).paginate(:page => params[:page])
    end
    unless params[:dni].nil?
      @patients = Patient.where('document_identity_code like "%'+params[:dni]+'%"') .order(id: :desc).paginate(:page => params[:page])
    end
    respond_to do |format|
      format.js
      format.html
    end
  end

  def add_monsant
    p = Patient.new(name: params[:name], paternal: params[:paternal], maternal: params[:maternal], document_identity_code: params[:document_identity_code], birthday: params[:birthday], is_monsanto: true)
    if p.save
      respond_to do |format|
        format.html { redirect_to form_monsant_path }
        format.js { @patient = p}
      end
    else
      p.id = 0
      respond_to do |format|
        format.html
        format.js {@patient = p}
      end
    end
  end

  def form_monsant
    
  end

  def clinic_history
    @patient = Patient.find(params[:patient_id])
    if @patient.current_age < 18
      @text = 'mi menor hijo'
      @text_name = @patient.representative
      @text_dni = @patient.document_identity_code_representative
    else
      @text = 'mi persona'
      @text_name = to_name_i(@patient)
      @text_dni = @patient.document_identity_code
    end
    
  end


  def anex_history
      @patient = Patient.find(params[:patient_id])
  end

  def new
    @insurances = to_hash(Insurance.order(:name))
    @companies = to_hash(Company.order(:name))
    @afiliation_types = to_hash(AfiliationType.all)
    @relation_ships = to_hash(RelationShip.all)
    @sex = {'Masculino' => 'M', 'Femenino' => 'F'}
  end

  def new_particular
    @sex = {'Masculino' => 'M', 'Femenino' => 'F'}
  end

  def open_company
    respond_to do |format|
      format.js
    end
  end

  def new_company
    @companies = to_hash(Company.order(:name))
  end

  def create_dni
    if request.post?
      patient = Patient.find(params[:patient_id])
      patient.document_identity_code = params[:dni]
      patient.save
      redirect_to show_patient_path(id: params[:patient_id])
    end
  end

  def get_paternal
    respond_to do |format|
      format.json { Patient.where('paternal like "%'+ params[:term] +'%" ').to_json  }
    end
  end

  def create
    Patient.new_patient_insured(params, current_employee.id)
    redirect_to patients_path(page: 1)
  end

  def create_particular
    Patient.new_patient_particular(params, current_employee.id)
    redirect_to patients_path(page: 1)
  end

  def create_company
    Company.create(ruc: params[:ruc], name: params[:name])
    @companies = to_hash(Company.order(:name))
    respond_to do |format|
      format.js
    end
  end

  def insert_dni
    @patient = Patient.find(params[:patient_id])
  end

  def destroy
    p = Patient.find(params[:patient_id])
    p.destroy
    redirect_to patients_path(page: 1)
  end

  def show
    @patient = Patient.find(params[:id])
    @quantity = 0
    @patient.authorizations.each do |a|
      InsuredService.where(authorization_id: a.id).each do |i|
        @quantity = @quantity + i.initial_amount.to_f
      end
      InsuredPharmacy.where(authorization_id: a.id).each do |i|
        @quantity = @quantity + i.initial_amount.to_f
      end
    end
    @quantity = @quantity.round(2)
  end

  def recent
  end

  def update_phone
    @patient.phone = params[:phone]
    p.save
    respond_to do |format|
      format.html {redirect_to clinic_history_path(patient_id: @patient.id)}
      format.js
    end
  end

  def update_other
    @patient.other = params[:other]
    @patient.save
    respond_to do |format|
      format.html {redirect_to clinic_history_path(patient_id: @patient.id)}
      format.js
    end
  end

  def update_dni
    @patient.document_identity_code = params[:document_identity_code]
    @patient.save 
    respond_to do |format|
      format.html {redirect_to clinic_history_path(patient_id: @patient.id)}
      format.js
    end
  end

  def update_representative
    @patient.representative = params[:representative]    
    @patient.document_identity_code_representative = params[:document_identity_code_representative]
    @patient.save 
    respond_to do |format|
      format.html {redirect_to show_patient_path(id: @patient.id)}
      format.js
    end
  end

  def udpate_date_generation
    p = Patient.find(params[:patient_id])
    p.date_generation = params[:date_generation]
    p.save
    respond_to do |format|
      format.html {redirect_to clinic_history_path(patient_id: p.id)}
      format.js {@patient = p}
    end
  end
  

  def update_direction
    p = Patient.find(params[:patient_id])
    p.direction = params[:direction]
    p.save
    respond_to do |format|
      format.html {redirect_to clinic_history_path(patient_id: p.id)}
      format.js {@patient = p}
    end
  end
  

  def redirect_to_print    
    respond_to do |format|
      format.html {redirect_to clinic_history_path(patient_id: @patient.id)}
      format.js
    end
  end

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end
end
