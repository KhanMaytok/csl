class PharmacySalesController < ApplicationController
  def new
  end

  def ready
  	@i_pharmacy = InsuredPharmacy.find(params[:id_pharm])
  	@authorization = Authorization.find(@i_pharmacy.authorization_id)
  	@product_pharm_types = ProductPharmType.all
  	@digemid_products = get_digemid_hash(DigemidProduct.all.order(:name))
    @product_pharm_exenteds = to_hash(ProductPharmExented.all)
  end

  def get_cum_sunasa_hash(query)
    hash = Hash.new
    query.each do |q|
      key = q.name.to_s + '... ' + q.measure.to_s + "  " + q.measure_unity.to_s
      hash[key] = q.id
    end
    hash
  end

  def get_digemid_hash(query)
    hash = Hash.new
    query.each do |q|
      key = q.name.to_s[0,50] + '... '+ q.concentration.to_s + "  " + q.fractions.to_s
      hash[key] = q.id
    end
    hash
  end

  def confirm_pharmacy
    if current_employee.area_id == 6
      i = InsuredPharmacy.create(authorization_id: params[:id_authorization], employee: current_employee, has_ticket: false)
    else
      i = InsuredPharmacy.create(authorization_id: params[:id_authorization], employee: current_employee, has_ticket: true)
    end
  	
  	redirect_to new_pharmacy_ready_path(id_pharm: i.id)
  end

  def add_pharmacy
  	p = PurchaseInsuredPharmacy.new
  	p.insured_pharmacy_id = params[:insured_pharmacy_id]
  	p.product_pharm_type_id = params[:product_pharm_type_id]
  	p.digemid_product_id = params[:digemid_product_id]
  	p.quantity = params[:quantity]
  	p.unitary = params[:unitary]
    p.product_pharm_exented_id = params[:product_pharm_exented_id]
  	p.save
  	redirect_to new_pharmacy_ready_path(id_pharm: p.insured_pharmacy.id)
  end

  def close_pharmacy
  	i = InsuredPharmacy.find(params[:id])
  	i.is_closed = params[:is_closed]
  	i.purchase_insured_pharmacies.each do |p|
  		i.initial_amount = i.initial_amount.to_f + p.initial_amount.to_f
  		i.copayment= i.copayment.to_f + p.copayment.to_f
  		i.igv = i.igv.to_f + p.igv.to_f
  		i.final_amount = i.final_amount.to_f + p.final_amount.to_f
	  end
  	i.save
  	redirect_to new_pharmacy_ready_path(id_pharm: i.id)
  end
end
