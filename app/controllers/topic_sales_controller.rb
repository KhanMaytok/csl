class TopicSalesController < ApplicationController
  def new
  	@authorization = Authorization.find(params[:id_authorization])
  end

  def ready
  	@insured_service = InsuredService.find(params[:id])
  	@services = Service.where(clinic_area_id: 2).order(:name)
  	@service_exenteds = to_hash(ServiceExented.all)
  end

  def confirm
    d = Authorization.find(params[:authorization_id]).doctor
    if current_employee.area_id == 6
      i = InsuredService.create(authorization_id: params[:id_authorization], employee: current_employee, doctor_id: d.id, clinic_area_id: 2, has_ticket: false)
    else
      i = InsuredService.create(authorization_id: params[:id_authorization], employee: current_employee, doctor_id: d.id, clinic_area_id: 2, has_ticket: true)
    end  	
  	redirect_to ready_topic_path(id: i.id)
  end

  def add
  	p = PurchaseInsuredService.new
  	p.service_id = params[:service_id]
  	p.insured_service_id = params[:insured_service_id]
  	p.quantity = params[:quantity]
  	p.unitary = params[:price]
    p.service_exented_id = params[:service_exented_id]
  	p.save
  	redirect_to ready_topic_path(id: p.insured_service.id)
  end

  def close
  	i = InsuredService.find(params[:id])
  	i.is_closed = params[:is_closed]
  	i.purchase_insured_services.each do |p|
  		i.initial_amount = i.initial_amount.to_f + p.initial_amount.to_f
  		i.copayment= i.copayment.to_f + p.copayment.to_f
  		i.igv = i.igv.to_f + p.igv.to_f
  		i.final_amount = i.final_amount.to_f + p.final_amount.to_f
	  end  
  	i.save
  	redirect_to ready_topic_path(id: i.id)
  end
end