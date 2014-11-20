class ServiceSalesController < ApplicationController
  respond_to :html, :js
  before_action :block_unloged
  def index
  end

  def show
  end

  def new
  	@services = Service.where(clinic_area_id: ClinicArea.find_by_name(params[:name]).id)
  	@clinic_area = ClinicArea.find_by_name(params[:name])
  	@authorization = Authorization.find(params[:id_authorization])
    @doctors = to_hash_doctor(Doctor.all.order(:complet_name))
  end

  def delete_service
    p = PurchaseInsuredService.find(params[:purchase_insured_service_id])
    i = p.insured_service    
    @i_service = InsuredService.find(p.insured_service)    
    if @i_service.clinic_area_id == 6
      @services = Service.where('clinic_area_id in (6,7)').order(:name)
    else
      @services = Service.where(clinic_area_id: @i_service.clinic_area_id).order(:name)
    end
    @codes = to_hash_code(Service.where(clinic_area_id: @i_service.clinic_area_id).order(:id))    
    @clinic_area = ClinicArea.find(@i_service.clinic_area_id)
    @authorization = Authorization.find(@i_service.authorization_id)
    @service_exenteds = to_hash(ServiceExented.all)
    p.destroy
    respond_to do |format|
      format.js
    end
  end

  def delete_service_sale
    i = InsuredService.find(params[:id_sale])
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

  def to_hash_doctor(query)
    hash = Hash.new
    query.each do |q|
      hash[q.complet_name] = q.id
    end
    hash
  end

  def to_hash_code(query)
    hash = Hash.new
    query.each do |q|
      hash[q.code] = q.id
    end
    hash
  end

  def confirm_sale
    if current_employee.area_id == 6
      i = InsuredService.create(authorization_id: params[:id_authorization], clinic_area_id: ClinicArea.find_by_name(params[:name]).id, employee: current_employee, doctor_id: params[:doctor_id], has_ticket: false)
    else
      i = InsuredService.create(authorization_id: params[:id_authorization], clinic_area_id: ClinicArea.find_by_name(params[:name]).id, employee: current_employee, doctor_id: params[:doctor_id], has_ticket: true)
    end
  	
  	redirect_to new_sales_ready_path(id_sale: i.id)
  end

  def add_service
  	p = PurchaseInsuredService.new
  	p.service_id = params[:service_id]
    unless params[:code_id].nil? or params[:code_id] == '' or params[:code_id] == 0
      p.service_id = Service.find(params[:code_id]).id
    end
  	p.insured_service_id = params[:insured_service_id]
  	p.quantity = params[:quantity]
    p.has_discount = params[:has_discount]
    p.service_exented_id = params[:service_exented_id]
  	p.save
    @i_service = InsuredService.find(p.insured_service)
    if @i_service.clinic_area_id == 6
      @services = Service.where('clinic_area_id in (6,7)').order(:name)
    else
      @services = Service.where(clinic_area_id: @i_service.clinic_area_id).order(:name)
    end
    @codes = to_hash_code(Service.where(clinic_area_id: @i_service.clinic_area_id).order(:id))    
    @clinic_area = ClinicArea.find(@i_service.clinic_area_id)
    @authorization = Authorization.find(@i_service.authorization_id)
    @service_exenteds = to_hash(ServiceExented.all)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    i = InsuredService.find(params[:insured_service_id])
    a = i.authorization
    i.destroy
    redirect_to show_authorization_path
  end

  def close_sale
  	i = InsuredService.find(params[:id])
  	i.is_closed = params[:is_closed]
  	i.purchase_insured_services.each do |p|
  		i.initial_amount = i.initial_amount.to_f + p.initial_amount.to_f
  		i.copayment= i.copayment.to_f + p.copayment.to_f
  		i.igv = i.igv.to_f + p.igv.to_f
  		i.final_amount = i.final_amount.to_f + p.final_amount.to_f
	  end  
  	i.save
    @i_service = i
    if @i_service.clinic_area_id == 6
      @services = Service.where('clinic_area_id in (6,7)').order(:name)
    else
      @services = Service.where(clinic_area_id: @i_service.clinic_area_id).order(:name)
    end
    @codes = to_hash_code(Service.where(clinic_area_id: @i_service.clinic_area_id).order(:id))    
    @clinic_area = ClinicArea.find(@i_service.clinic_area_id)
    @authorization = Authorization.find(@i_service.authorization_id)
    @service_exenteds = to_hash(ServiceExented.all)
    respond_to do |format|
      format.js
    end
  end

  def open_sale
    i = InsuredService.find(params[:id])
    i.is_closed = params[:is_closed]
    i.initial_amount = 0
    i.copayment= 0
    i.igv = 0
    i.final_amount = 0
    i.save
    @i_service = i
    if @i_service.clinic_area_id == 6
      @services = Service.where('clinic_area_id in (6,7)').order(:name)
    else
      @services = Service.where(clinic_area_id: @i_service.clinic_area_id).order(:name)
    end
    @codes = to_hash_code(Service.where(clinic_area_id: @i_service.clinic_area_id).order(:id))    
    @clinic_area = ClinicArea.find(@i_service.clinic_area_id)
    @authorization = Authorization.find(@i_service.authorization_id)
    @service_exenteds = to_hash(ServiceExented.all)
    respond_to do |format|
      format.js
    end
  end

  def change_name_code
  end
end
