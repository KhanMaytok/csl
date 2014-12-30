class PharmacySalesController < ApplicationController
  respond_to :html, :js
  before_action :block_unloged
  def new
    if current_employee.area_id == 3
      @pharm_type_sales = to_hash(PharmTypeSale.where(id: 2))
    else
      @pharm_type_sales = to_hash(PharmTypeSale.all)
    end
    
  end
  
  def index
    @insured_pharmacies = InsuredPharmacy.where(pharm_type_sale_id: 2).order('abs(liquidation) DESC').paginate(:page => params[:page])
    unless params[:date].nil?
      @insured_pharmacies = InsuredPharmacy.where('pharm_type_sale_id = 2 and created_at like "%'+params[:date]+'%" and liquidation like "%'+ params[:liquidation]+ '%"').order('abs(liquidation) DESC').paginate(:page => params[:page])
    end
  end

  def ready
  	@i_pharmacy = InsuredPharmacy.find(params[:id_pharm])
    @username = @i_pharmacy.employee.username
  	@authorization = Authorization.find(@i_pharmacy.authorization_id)
  	@product_pharm_types = ProductPharmType.all
  	@digemid_products = get_digemid_hash(DigemidProduct.all.order(:name))
    @product_pharm_exenteds = to_hash(ProductPharmExented.all)
    if @i_pharmacy.authorization.patient.insured.insurance_id == 3
      @porc = "20%"
    else
      @porc = "10%"
    end
  end

  def print
    @pharm = InsuredPharmacy.find(params[:pharmacy_id])
    @igv = @pharm.initial_amount*0.18
    if @pharm.purchase_insured_pharmacies.last.product_pharm_exented_id == 2
      @igv = 0
    end
    if @pharm.authorization.patient.insured.insurance_id == 3
      @porc = "20%"
    else
      @porc = "10%"
    end
    @without_igv = @pharm.without_igv
    @first_copayment = @pharm.first_copayment 
    @total_amount = @pharm.initial_amount + @igv
    @patient=@pharm.authorization.patient
    @high = 13 - @pharm.purchase_insured_pharmacies.count
    @complete_name=@patient.paternal + " " + @patient.maternal+  " " +@patient.name
  end

  def delete_pharmacy
    p = PurchaseInsuredPharmacy.find(params[:purchase_insured_pharmacy_id])
    i = p.insured_pharmacy
    p.destroy
    @i_pharmacy = InsuredPharmacy.find(p.insured_pharmacy.id)
    if @i_pharmacy.authorization.patient.insured.insurance_id == 3
      @porc = "20%"
    else
      @porc = "10%"
    end
    @authorization = Authorization.find(p.insured_pharmacy.authorization_id)
    @product_pharm_types = ProductPharmType.all
    @digemid_products = get_digemid_hash(DigemidProduct.all.order(:name))
    @product_pharm_exenteds = to_hash(ProductPharmExented.all)
    respond_to do |format|
      format.js
    end
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
      key = q.name.to_s[0,50] + '... '+ q.concentration.to_s + "  " + q.fractions.to_s + " " + q.form
      hash[key] = q.id
    end
    hash
  end

  def confirm_pharmacy
    d = Authorization.find(params[:id_authorization]).doctor

    if current_employee.area_id == 6
      i = InsuredPharmacy.create(time_create: Time.now, created_at: Time.now, pharm_type_sale_id: params[:pharm_type_sale_id], authorization_id: params[:id_authorization], employee: current_employee, has_ticket: false)
    else
      i = InsuredPharmacy.create(time_create: Time.now, created_at: Time.now, pharm_type_sale_id: params[:pharm_type_sale_id], authorization_id: params[:id_authorization], employee: current_employee,  has_ticket: true)
    end
    if params[:pharm_type_sale_id] == '1' or params[:pharm_type_sale_id] == 1
      
      i.liquidation = (InsuredPharmacy.where(pharm_type_sale_id: 1).count + 100).to_s
    else
      unless current_employee.area_id == 3
        i.liquidation = '00'
      else
         i.liquidation = get_max(InsuredPharmacy.where(pharm_type_sale_id: 2)).to_s
      end     
    end
    i.save

  	redirect_to new_pharmacy_ready_path(id_pharm: i.id)
  end

  def get_max(query)
    max = 0
    query.each do |q|
      if q.liquidation.nil?
        max = max
      else
        if [q.liquidation.to_i, max.to_i].max == q.liquidation.to_i
          max = q.liquidation
        else
          max = max
        end
      end      
    end
    return (max.to_i + 1).to_s
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
    @i_pharmacy = InsuredPharmacy.find(params[:insured_pharmacy_id])
    if @i_pharmacy.authorization.patient.insured.insurance_id == 3
      @porc = "20%"
    else
      @porc = "10%"
    end
    @authorization = Authorization.find(@i_pharmacy.authorization_id)
    @product_pharm_types = ProductPharmType.all
    @digemid_products = get_digemid_hash(DigemidProduct.all.order(:name))
    @product_pharm_exenteds = to_hash(ProductPharmExented.all)
    respond_to do |format|
      format.js
      format.html {redirect_to new_pharmacy_ready_path(id_pharm: @i_pharmacy)}
    end
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
  def change_date
    i = InsuredPharmacy.find(params[:insured_pharmacy_id])
    i.created_at = params[:created_at] + " " + i.created_at.strftime("%H:%M:%S")
    i.save
    redirect_to new_pharmacy_ready_path(id_pharm: i.id)
  end

  def close_pharmacy
  	i = InsuredPharmacy.find(params[:id])
  	i.is_closed = params[:is_closed]
  	i.purchase_insured_pharmacies.each do |p|
      i.without_igv = i.without_igv.to_f + p.without_igv
      i.first_copayment = i.first_copayment.to_f + p.first_copayment
  		i.initial_amount = i.initial_amount.to_f + p.initial_amount.to_f
  		i.copayment= i.copayment.to_f + p.copayment.t
  		i.igv = i.igv.to_f + p.igv.to_f
  		i.final_amount = i.final_amount.to_f + p.final_amount.to_f
	  end
  	i.save
    @i_pharmacy = InsuredPharmacy.find(params[:id])
    if @i_pharmacy.authorization.patient.insured.insurance_id == 3
      @porc = "20%"
    else
      @porc = "10%"
    end
    @authorization = Authorization.find(@i_pharmacy.authorization_id)
    @product_pharm_types = ProductPharmType.all
    @digemid_products = get_digemid_hash(DigemidProduct.all.order(:name))
    @product_pharm_exenteds = to_hash(ProductPharmExented.all)
    respond_to do |format|
      format.js
      format.html{redirect_to new_pharmacy_ready_path(id_pharm: i.id)}
    end
  end

  def open_pharmacy
    i = InsuredPharmacy.find(params[:id])
    i.is_closed = nil
    i.without_igv = 0
    i.first_copayment = 0
    i.initial_amount = 0
    i.copayment = 0
    i.igv = 0
    i.final_amount = 0
    i.save
    @i_pharmacy = InsuredPharmacy.find(params[:id])
    if @i_pharmacy.authorization.patient.insured.insurance_id == 3
      @porc = "20%"
    else
      @porc = "10%"
    end
    @authorization = Authorization.find(@i_pharmacy.authorization_id)
    @product_pharm_types = ProductPharmType.all
    @digemid_products = get_digemid_hash(DigemidProduct.all.order(:name))
    @product_pharm_exenteds = to_hash(ProductPharmExented.all)
    respond_to do |format|
      format.js
    end
  end
  def print_all
    unless params[:date_initial].nil?
      @pharm = InsuredPharmacy.where('created_at >="'+params[:date_initial].to_s+'" and created_at <= "'+params[:date_final].to_s + '"').paginate(:page => params[:page])     
    else
      @pharm = InsuredPharmacy.all.paginate(:page => params[:page])     
    end
     
  
  end
  def verify_by_date
    
    @mostrar=InsuredPharmacy.where('created_at >'+params[:date_initial].to_s+'and created_at <'+params[:date_final].to_s  )
  end
end
