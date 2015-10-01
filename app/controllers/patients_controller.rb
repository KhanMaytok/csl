class PatientsController < ApplicationController
  respond_to :html, :js, :json
  before_action :block_unloged
  before_action :set_patient, only: [:update_clinic_history_code, :update, :update_other, :update_dni, :update_phone, :update_representative]

  def index
    @patients = Patient.order('convert(clinic_history_code, decimal) DESC').paginate(:page => params[:page])
    unless params[:paternal].nil?
      @patients = Patient.where('paternal like "%'+params[:paternal]+'%" and maternal like "%'+params[:maternal]+'%" and name like "%'+params[:name]+'%"').order('convert(clinic_history_code, decimal) DESC').paginate(:page => params[:page])
    end
    unless params[:dni].nil?
      @patients = Patient.where('document_identity_code like "%'+params[:dni]+'%"').order('convert(clinic_history_code, decimal) DESC').paginate(:page => params[:page])
    end
    @insurances = to_hash(Insurance.order(:name))
    @companies = to_hash(Company.order(:name))
    @afiliation_types = to_hash(AfiliationType.all)
    @relation_ships = to_hash(RelationShip.all)
    @sex = {'Masculino' => 'M', 'Femenino' => 'F'}
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
    patient = Patient.find(params[:patient_id])
    patient.document_identity_code = params[:document_identity_code]
    patient.save
    redirect_to show_patient_path(id: params[:patient_id])
  end

  def get_paternal
    respond_to do |format|
      format.json { Patient.where('paternal like "%'+ params[:term] +'%" ').to_json  }
    end
  end

  def create
    p = Patient.new(phone: params[:phone], document_identity_type_id: 1, document_identity_code: params[:document_identity_code], name: params[:name].upcase, paternal: params[:paternal].upcase, maternal: params[:maternal].upcase, birthday: params[:birthday], age: params[:age], employee_id: params[:employee_id], is_insured: true, sex: params[:sex])
    i = Insured.last
    if p.save
      c = Company.find(params[:company_id])
      if params[:afiliation_type_id] == '3'
        holder_paternal = c.name
      else
        holder_paternal = params[:holder_paternal]
      end
      i = Insured.create(insurance_id: params[:insurance_id] ,afiliation_type_id: params[:afiliation_type_id], company_id: c.id, patient_id: p.id, code: params[:insured_code], hold_paternal: holder_paternal, hold_maternal: params[:holder_maternal], hold_name: params[:holder_name], relation_ship_id: params[:relation_ship_id], card_number: params[:insured_code], company_name: c.name)
      i.save
      respond_to do |format|
        format.html { redirect_to redirect_to patients_path(page: 1) }
        format.js do
          @patient = p
          @insured = i
          @patients = Patient.order('convert(clinic_history_code, decimal) DESC').paginate(:page => params[:page])
        end
      end
    end
  end

  def create_particular
    p = Patient.new(phone: params[:phone], document_identity_type_id: 1, document_identity_code: params[:document_identity_code], name: params[:name].upcase, paternal: params[:paternal].upcase, maternal: params[:maternal].upcase, birthday: params[:birthday], age: params[:age], employee_id: params[:employee_id], is_insured: nil, sex: params[:sex])
    p.save
    @patients = Patient.order('convert(clinic_history_code, decimal) DESC').paginate(:page => params[:page])
    respond_to do |format|
      format.html { redirect_to patients_path(page: 1) }
      format.js { @patient = p }
    end
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
    @companies = to_hash(Company.all.order(:name))
    @relation_ships = to_hash(RelationShip.all.order(:name))
    @insurances = to_hash(Insurance.all.order(:name))
    @afiliation_types = to_hash(AfiliationType.order(:name))
    @sex = {'Masculino' => 'M', 'Femenino' => 'F'}
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

  def add_insured
    patient = Patient.find(params[:patient_id])
    patient.is_insured = true
    insured = Insured.create(patient_id: params[:patient_id], company_id: params[:company_id], relation_ship_id: params[:relation_ship_id], insurance_id: params[:insurance_id], afiliation_type_id: params[:afiliation_type_id], code: params[:insured_code], hold_name: params[:holder_name], hold_paternal: params[:holder_paternal], hold_maternal: params[:holder_maternal])
    patient.save

    redirect_to show_patient_path(id: patient.id)
  end

  def recent
  end

  def update
    @patient.update!(document_identity_code: params[:document_identity_code], paternal: params[:paternal], maternal: params[:maternal], name: params[:name], sex: params[:sex], birthday: params[:birthday], phone: params[:phone], direction: params[:direction])
    @patient.save
    redirect_to show_patient_path(id: @patient.id)
  end

  def update_phone
    @patient.phone = params[:phone]
    @patient.save
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
      format.js
    end
  end

  def update_clinic_history_code
    @patient.update(clinic_history_code: params[:clinic_history_code])    
    @insurances = to_hash(Insurance.order(:name))
    @companies = to_hash(Company.order(:name))
    @afiliation_types = to_hash(AfiliationType.all)
    @relation_ships = to_hash(RelationShip.all)
    @sex = {'Masculino' => 'M', 'Femenino' => 'F'}
    @patients = Patient.order('convert(clinic_history_code, decimal) DESC').paginate(:page => params[:page])
    respond_to do |format|
      format.html {redirect_to patients_path(page: 1)}
      format.js
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
