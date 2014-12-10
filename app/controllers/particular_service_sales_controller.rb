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
    
    @clinic_area = Cli nicArea.find(@i_service.clinic_area_id)
    @authorization = Authorization.find(@i_service.authorization_id)
    @service_exenteds = to_hash(ServiceExented.all)
  end

  def show
  end
  def delete_service_sale
    i = ParticularService.find(params[:id_sale])
    i.purchase_insured_services.each do |p|
      DetailService.where(index: p.id).each do |d|
        if d.service_code != '50.01.01' and d.service_code != '50.02.03' and d.service_code != '50.02.03'
          d.destroy
        end
      end           
    end
    a = i.authorization
    i.destroy
    redirect_to show_authorization_path(id: a.id)
  end

  def confirm_sale
    if current_employee.area_id == 6
      i = InsuredService.create(authorization_id: params[:id_authorization], clinic_area_id: ClinicArea.find_by_name(params[:name]).id, employee: current_employee, doctor_id: params[:doctor_id], has_ticket: false)
    else
      i = InsuredService.create(authorization_id: params[:id_authorization], clinic_area_id: ClinicArea.find_by_name(params[:name]).id, employee: current_employee, doctor_id: params[:doctor_id], has_ticket: true)
    end
    
    redirect_to new_sales_ready_particular_path(id_sale: i.id)
  end
  def to_hash_code(query)
    hash = Hash.new
    query.each do |q|
      hash[q.code] = q.id
    end
    hash
  end

end
