class ParticularServiceSalesController < ApplicationController


  def index
  end

  def new
    @services = Service.where(clinic_area_id: ClinicArea.find_by_name(params[:name]).id)
    @clinic_area = ClinicArea.find_by_name(params[:name])
    @authorization = Authorization.find(params[:id_authorization])
    @doctors = to_hash_doctor(Doctor.all.order(:complet_name))
  end

  def to_hash_doctor(query)
    hash = Hash.new
    query.each do |q|
      hash[q.complet_name + " " + q.tuition_code] = q.id
    end
    hash
  end
    
  def ready_sales
     @service = 0
    @i_service = InsuredService.find(params[:id_sale])
    @codes = to_hash_code(Service.where(clinic_area_id: @i_service.clinic_area_id).order(:id))
    if @i_service.clinic_area_id == 6
      @services = Service.where('clinic_area_id in (6,7)').order(:name)
    else
      @services = Service.where(clinic_area_id: @i_service.clinic_area_id).order(:name)
    end
    
    @clinic_area = ClinicArea.find(@i_service.clinic_area_id)
    @authorization = Authorization.find(@i_service.authorization_id)
    @service_exenteds = to_hash(ServiceExented.all)
  end

  def show
  end
end
