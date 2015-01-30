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

  def all
    @authorization = Authorization.find(params[:authorization_id])
    @clinic_areas = ClinicArea.all
    @doctors = Doctor.all.order(:complet_name)
    @insured_services = @authorization.insured_services
    @service_exenteds = to_hash(ServiceExented.all) 
  end

  def add_all
    insured_service = InsuredService.new(authorization_id: params[:authorization_id], doctor_id: params[:doctor_id], clinic_area_id: params[:clinic_area_id])
    insured_service.save
    purchase_insured_service = PurchaseInsuredService.new(insured_service: insured_service, service_id: params[:service_id], unitary: params[:unitary], quantity: params[:quantity], factor: params[:factor], service_exented_id: params[:service_exented_id])
    purchase_insured_service.save
    insured_service.is_closed = true
    insured_service.initial_amount = purchase_insured_service.initial_amount
    insured_service.copayment = purchase_insured_service.copayment
    insured_service.igv = purchase_insured_service.igv
    insured_service.final_amount = purchase_insured_service.final_amount
    insured_service.save
    @authorization = insured_service.authorization
    @insured_services = @authorization.insured_services
    @doctors = Doctor.all
    respond_to do |format|
      format.html {redirect_to insured_services_all_path(authorization_id: @authorization.id)}
      format.js
    end
  end

  def delete_from_all
    @authorization = Authorization.find(params[:authorization_id])
    @purchase_insured_service = PurchaseInsuredService.find(params[:purchase_insured_service_id])
    i = @purchase_insured_service.insured_service
    @purchase_insured_service.destroy
    @doctors = Doctor.all
    if i.purchase_insured_services.count == 0
      i.destroy
    end
    @insured_services = @authorization.insured_services
    respond_to do |format|
      format.html {redirect_to insured_services_all_path(authorization_id: @authorization.id)}
      format.js
    end
  end

  def update_all
    p = PurchaseInsuredService.find(params[:purchase_insured_service_id])
    i = p.insured_service
    i.doctor_id = params[:doctor_id]
    p.unitary = params[:unitary]
    p.factor = params[:factor]
    p.quantity = params[:quantity]
    p.save
    i.save
    @purchase_insured_service = p
    @authorization = i.authorization
    @insured_services = @authorization.insured_services
    @doctors = Doctor.all
    respond_to do |format|
      format.js
    end
  end

  def update_service
    @clinic_area = ClinicArea.find(params[:clinic_area_id])
    @services = Service.where(clinic_area_id: @clinic_area.id).order(:name)
    respond_to do |format|
      format.js
    end
  end

  def update_unitary
    service = Service.find(params[:service_id])
    a = Authorization.where(id: params[:authorization_id])
    if a.exists?
      authorization = Authorization.find(params[:authorization_id])
      @factor = Factor.where(clinic_area: service.clinic_area, insurance: authorization.insurance).last.factor
    end    
    @unitary = service.unitary
    respond_to do |format|
      format.js
    end
  end

  def update_name
    @service = Service.find(params[:service_id])
    respond_to do |format|
      format.js
    end
  end

  def update_code
    @service = Service.find(params[:service_id])
    respond_to do |format|
      format.js
    end
  end

  def delete_service
    p = PurchaseInsuredService.find(params[:purchase_insured_service_id])
    i = p.insured_service    
    @i_service = InsuredService.find(p.insured_service) 
    @services = Service.where(clinic_area_id: @i_service.clinic_area_id).order(:name)
    @codes = to_hash_code(Service.where(clinic_area_id: @i_service.clinic_area_id).order(:id))    
    @clinic_area = ClinicArea.find(@i_service.clinic_area_id)
    @authorization = Authorization.find(@i_service.authorization_id)
    @service_exenteds = to_hash(ServiceExented.all)
    p.destroy
    respond_to do |format|
      format.js
      format.html{redirect_to new_sales_ready_path(id_sale: @i_service.id)}
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
    @services = Service.where(clinic_area_id: @i_service.clinic_area_id).order(:name)
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

  def update_purchase_service
    p = PurchaseInsuredService.find(params[:purchase_insured_service_id])
    p.unitary = params[:unitary]
    p.save
    @i_service = InsuredService.find(p.insured_service)
    @services = Service.where(clinic_area_id: @i_service.clinic_area_id).order(:name)
    @codes = to_hash_code(Service.where(clinic_area_id: @i_service.clinic_area_id).order(:id))    
    @clinic_area = ClinicArea.find(@i_service.clinic_area_id)
    @authorization = Authorization.find(@i_service.authorization_id)
    @service_exenteds = to_hash(ServiceExented.all)
    respond_to do |format|
      format.js
    end
  end

  def add_service
  	p = PurchaseInsuredService.new
  	p.service_id = params[:service_id]
    p.factor = params[:factor]
    p.unitary = params[:unitary]
  	p.insured_service_id = params[:insured_service_id]
  	p.quantity = params[:quantity]
    p.service_exented_id = params[:service_exented_id]
  	p.save
    @i_service = InsuredService.find(p.insured_service)
    @services = Service.where(clinic_area_id: @i_service.clinic_area_id).order(:name)
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
  		i.initial_amount = i.initial_amount.to_f.round(2) + p.initial_amount.to_f.round(2)
  		i.copayment= i.copayment.to_f + p.copayment.to_f
  		i.igv = i.igv.to_f + p.igv.to_f
  		i.final_amount = i.final_amount.to_f + p.final_amount.to_f
	  end  
  	i.save
    @i_service = i
    @services = Service.where(clinic_area_id: @i_service.clinic_area_id).order(:name)
    @codes = to_hash_code(Service.where(clinic_area_id: @i_service.clinic_area_id).order(:id))    
    @clinic_area = ClinicArea.find(@i_service.clinic_area_id)
    @authorization = Authorization.find(@i_service.authorization_id)
    @service_exenteds = to_hash(ServiceExented.all)
    respond_to do |format|
      format.js
    end
  end

  def open_sale
    @i_service = InsuredService.find(params[:id])
    @i_service.is_closed = params[:is_closed]
    @i_service.initial_amount = 0
    @i_service.copayment= 0
    @i_service.igv = 0
    @i_service.final_amount = 0
    @i_service.save
    @services = Service.where(clinic_area_id: @i_service.clinic_area_id).order(:name)    
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
