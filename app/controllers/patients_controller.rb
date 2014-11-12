class PatientsController < ApplicationController
	before_action :block_unloged
  def index
    @patients = Patient.order(id: :desc).paginate(:page => params[:page])
    unless params[:paternal].nil?
      @patients = Patient.where('paternal like "%'+params[:paternal]+'%" and maternal like "%'+params[:maternal]+'%"') .order(id: :desc).paginate(:page => params[:page])
    end
  end

  def new
    @insurances = to_hash(Insurance.order(:name))
    @companies = to_hash(Company.order(:name))
    @afiliation_types = to_hash(AfiliationType.all)
    @relation_ships = to_hash(RelationShip.all)
    @sex = {'Masculino' => 'M', 'Femenino' => 'F'}
  end

  def new_particular
    
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

  def create
    Patient.new_patient(params, current_employee.id)
    redirect_to patients_path(page: 1)
  end

  def insert_dni
    @patient = Patient.find(params[:patient_id])
  end

  def show
    @patient = Patient.find(params[:id])
  end

  def recent
  end
end
