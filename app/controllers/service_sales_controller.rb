class ServiceSalesController < ApplicationController
  before_action :block_unloged
  def index
  end

  def show
  end

  def new
  	@services = Service.where(clinic_area_id: ClinicArea.find_by_name(params[:name]).id)
  	@clinic_area = ClinicArea.find_by_name(params[:name])
  	@authorization = Authorization.find(params[:id_authorization])
  end

  def ready_sales
  	@i_service = InsuredService.find(params[:id_sale])
  	@services = Service.where(clinic_area_id: @i_service.clinic_area_id).order(:name)
  	@clinic_area = ClinicArea.find(@i_service.clinic_area_id)
  	@authorization = Authorization.find(@i_service.authorization_id)
    @service_exenteds = to_hash(ServiceExented.all)
  end

  def confirm_sale
    if current_employee.area_id == 6
      i = InsuredService.create(authorization_id: params[:id_authorization], clinic_area_id: ClinicArea.find_by_name(params[:name]).id, employee: current_employee, has_ticket: false)
    else
      i = InsuredService.create(authorization_id: params[:id_authorization], clinic_area_id: ClinicArea.find_by_name(params[:name]).id, employee: current_employee, has_ticket: true)
    end
  	
  	redirect_to new_sales_ready_path(id_sale: i.id)
  end

  def add_service
  	p = PurchaseInsuredService.new
  	p.service_id = params[:service_id]
  	p.insured_service_id = params[:insured_service_id]
  	p.quantity = params[:quantity]
    p.service_exented_id = params[:service_exented_id]
  	p.save
  	redirect_to new_sales_ready_path(id_sale: p.insured_service.id)
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
  	redirect_to new_sales_ready_path(id_sale: i.id)
  end
end
