class CoverageSalesController < ApplicationController
  def new
  	@authorization = Authorization.find(params[:id])
  end

  def ready
  	@insured_service = InsuredService.find(params[:id])
  	@services = to_hash(Service.where(code: '500101').order(:name))
  end

  def confirm
  	i = InsuredService.create(authorization_id: params[:authorization_id])
  	redirect_to ready_coverage_path(id: i.id)
  end

  def add

  	i = InsuredService.find(params[:insured_service_id])
  	p = PurchaseCoverageService.new(insured_service_id: i.id)
  	p.unitary = params[:unitary]
  	p.service_id = params[:service_id]
	p.copayment = (i.authorization.coverage.cop_fijo/1.18).round(2)
  	p.igv = i.authorization.coverage.cop_fijo - p.copayment
  	p.final_amount = i.authorization.coverage.cop_fijo
  	p.save
  	redirect_to ready_coverage_path(id: i.id)
  end

  def close
  	i = InsuredService.find(params[:id])
  	i.is_closed = params[:is_closed]
  	p = i.purchase_coverage_service
  		i.initial_amount = i.initial_amount.to_f + p.unitary.to_f
  		i.copayment= i.copayment.to_f + p.copayment.to_f
  		i.igv = i.igv.to_f + p.igv.to_f
  		i.final_amount = i.final_amount.to_f + p.final_amount.to_f
  	i.save
  	redirect_to ready_coverage_path(id: i.id)
  end
end
	