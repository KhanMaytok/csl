class PatientsController < ApplicationController
  respond_to :html, :js, :json
	before_action :block_unloged
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

  def clinic_history
    @patient = Patient.find(params[:patient_id])
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
end
