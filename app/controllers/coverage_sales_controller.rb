class CoverageSalesController < ApplicationController
  before_action :block_unloged
  def new
  	@authorization = Authorization.find(params[:id])
  end

  def ready
  	@insured_service = InsuredService.find(params[:id])
  	@services = to_hash(Service.where('code = "50.01.01" or code = "50.02.01" or code = "50.02.03" or code = "50.02.04" or code = "50.02.06"').order(:name))
  end

  def confirm
    d = Authorization.find(params[:authorization_id]).doctor
    a = Authorization.find(params[:authorization_id])
    a.has_consultation = true
    a.save
    if current_employee.area_id == 6 
      i = InsuredService.create(authorization_id: params[:authorization_id], employee: current_employee, doctor_id: d.id, has_ticket: false, is_consultation: true)
    else
      i = InsuredService.create(authorization_id: params[:authorization_id], employee: current_employee, doctor_id: d.id, has_ticket: true, is_consultation: true)
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

  def fast_close
    d = Authorization.find(params[:authorization_id]).doctor
    a = Authorization.find(params[:authorization_id])
    
    a.has_consultation = true
    unitary = a.patient.insured.insurance.consultation
    i = InsuredService.create(authorization_id: params[:authorization_id], employee: current_employee, doctor_id: d.id, has_ticket: false, is_consultation: true)
    p = PurchaseCoverageService.new(insured_service_id: i.id)
    p.unitary = unitary
    p.service_id = 1550
    if params[:unitary] == 0 or params[:unitary].nil? or params[:unitary] == ''
      p.copayment = (i.authorization.coverage.cop_fijo/1.18).round(2)
    else
      p.unitary = params[:unitary]
      p.copayment = params[:unitary]
    end    
    p.igv = (p.copayment * 0.18).round(2)
    p.final_amount = p.copayment + p.igv
    i.initial_amount = i.initial_amount.to_f + p.unitary.to_f
    i.copayment= i.copayment.to_f + p.copayment.to_f
    i.igv = i.igv.to_f + p.igv.to_f
    i.final_amount = i.final_amount.to_f + p.final_amount.to_f
    i.is_closed = true
    i.save
    a.save
    p.save
    redirect_to show_authorization_path(id: a.id)
  end

  def delete
    c = InsuredService.find(params[:insured_service_id])
    p = c.purchase_coverage_service
    a = c.authorization
    a.has_consultation = nil
    c.destroy
    unless p.nil?    
      if DetailService.where(index: p.id, purchase_code: 'C').exists?
        d = DetailService.where(index: p.id, purchase_code: 'C').last
        d.destroy
      end
      p.destroy
    end
    a.save
    redirect_to show_authorization_path(id: a.id)
  end
end
	