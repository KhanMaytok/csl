class CoverageSalesController < ApplicationController
  before_action :block_unloged
  def new
  	@authorization = Authorization.find(params[:id])
  end

  def ready
  	@insured_service = InsuredService.find(params[:id])
  	@services = to_hash(Service.where(code: '50.01.01').order(:name))
  end

  def confirm
    if current_employee.area_id == 6
      i = InsuredService.create(authorization_id: params[:authorization_id], employee: current_employee, has_ticket: false)
    else
      i = InsuredService.create(authorization_id: params[:authorization_id], employee: current_employee, has_ticket: true)
    end  	
  	redirect_to ready_coverage_path(id: i.id)
  end

  def add
  	i = InsuredService.find(params[:insured_service_id])
  	p = PurchaseCoverageService.new(insured_service_id: i.id)
  	p.unitary = params[:unitary]
  	p.service_id = params[:service_id]
	  p.copayment = (i.authorization.coverage.cop_fijo/1.18).round(2)
  	p.igv = (p.copayment * 0.18).round(2)
  	p.final_amount = p.copayment + p.igv
  	p.save
  	redirect_to ready_coverage_path(id: i.id)
  end

  def close
  	i = InsuredService.find(params[:id])
  	i.is_closed = params[:is_closed]
    a = i.authorization
    a.has_consultation = true
  	p = i.purchase_coverage_service
  		i.initial_amount = i.initial_amount.to_f + p.unitary.to_f
  		i.copayment= i.copayment.to_f + p.copayment.to_f
  		i.igv = i.igv.to_f + p.igv.to_f
  		i.final_amount = i.final_amount.to_f + p.final_amount.to_f
  	i.save
    a.save
  	redirect_to ready_coverage_path(id: i.id)
  end
end
	