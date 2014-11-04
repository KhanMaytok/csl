class PharmacySalesController < ApplicationController
  before_action :block_unloged
  def new
    @pharm_type_sales = to_hash(PharmTypeSale.all)
  end

  def ready
  	@i_pharmacy = InsuredPharmacy.find(params[:id_pharm])
  	@authorization = Authorization.find(@i_pharmacy.authorization_id)
  	@product_pharm_types = ProductPharmType.all
  	@digemid_products = get_digemid_hash(DigemidProduct.all.order(:name))
    @product_pharm_exenteds = to_hash(ProductPharmExented.all)
  end

  def print
    @pharm = InsuredPharmacy.find(params[:pharmacy_id])
    @igv = @pharm.initial_amount*0.18
    @total_amount = @pharm.initial_amount + @igv
    @patient=@pharm.authorization.patient
    @complete_name=@patient.name+ " " +@patient.paternal + " " + @patient.maternal
  end

  def delete_pharmacy
    p = PurchaseInsuredPharmacy.find(params[:purchase_insured_pharmacy_id])
    i = p.insured_pharmacy
    p.destroy
    redirect_to new_pharmacy_ready_path(id_pharm: i.id)
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
    d = Authorization.find(params[:id_authorization]).doctor

    if current_employee.area_id == 6
      i = InsuredPharmacy.create(pharm_type_sale_id: params[:pharm_type_sale_id], authorization_id: params[:id_authorization], employee: current_employee, has_ticket: false)
    else
      i = InsuredPharmacy.create(pharm_type_sale_id: params[:pharm_type_sale_id], authorization_id: params[:id_authorization], employee: current_employee,  has_ticket: true)
    end
    if params[:pharm_type_sale_id] == '1' or params[:pharm_type_sale_id] == 1
      i.liquidation = (InsuredPharmacy.where(pharm_type_sale_id: 1).count + 100).to_s
    else
      i.liquidation = (InsuredPharmacy.where(pharm_type_sale_id: 2).count + 13000).to_s
    end
    i.save

  	redirect_to new_pharmacy_ready_path(id_pharm: i.id)
  end

  def add_pharmacy
  	p = PurchaseInsuredPharmacy.new
  	p.insured_pharmacy_id = params[:insured_pharmacy_id]
    p.product_pharm_type_id = params[:product_pharm_type_id]
    if p.product_pharm_type_id != 1
      p.name = params[:name]
    else
      p.digemid_product_id = params[:digemid_product_id]
    end  	
  	p.quantity = params[:quantity]
  	p.unitary = params[:unitary]
    p.product_pharm_exented_id = params[:product_pharm_exented_id]
  	p.save
  	redirect_to new_pharmacy_ready_path(id_pharm: p.insured_pharmacy.id)
  end

  def add_liquidation
    @insured_pharmacy = InsuredPharmacy.find(params[:insured_pharmacy_id])
    @insured_pharmacy.liquidation = params[:liquidation]
    @insured_pharmacy.save
    redirect_to new_pharmacy_ready_path(id_pharm: @insured_pharmacy.id)
  end 

  def drop_pharmacy
    insured_pharmacy = InsuredPharmacy.find(params[:insured_pharmacy_id])
    authorization = insured_pharmacy.authorization
    insured_pharmacy.purchase_insured_pharmacies.each do |p|
      unless DetailPharmacy.where(index: p.id).last.nil?
        d = DetailPharmacy.where(index: p.id).last
        d.destroy
      end
      p.destroy
    end
    insured_pharmacy.destroy
    redirect_to show_authorization_path(id: authorization.id)
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
