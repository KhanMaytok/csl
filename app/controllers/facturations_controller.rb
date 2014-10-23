class FacturationsController < ApplicationController
  before_action :block_unloged
  def index   
    if params[:authorization_code].nil? and params[:paternal].nil?
      @authorizations = Authorization.order(date: :desc).paginate(:page => params[:page])
    else
      if params[:paternal].nil?
        @authorizations = Authorization.where(code: params[:authorization_code]).order(date: :desc).paginate(:page => params[:page])  
      else
        @authorizations = Authorization.all.joins(:patient).where('patients.paternal like "'+params[:paternal] +'%"').order(date: :desc).paginate(:page => params[:page])  
      end            
    end
  end

  def list
    if params[:insurance].nil?
      @pay_documents = PayDocument.all.where(is_closed: true).order(id: :desc).paginate(:page => params[:page])
    else
      @pay_documents = PayDocument.all.where(is_closed: true, insurance_ruc: params[:insurance]).order(id: :desc).paginate(:page => params[:page])
    end
    unless params[:code].nil?
       @pay_documents = PayDocument.all.where('is_closed = true and code like "%'+params[:code].to_s+'%"').order(id: :desc).paginate(:page => params[:page])
    end
    unless params[:authorization_code].nil?
       @pay_documents = PayDocument.joins(:authorization).all.where('pay_documents.is_closed = true and authorizations.code like "%'+params[:authorization_code].to_s+'%"').order(id: :desc).paginate(:page => params[:page])
    end
    @insurances = {'Pacífico Peruana Suiza CIA de Seguros' => '20100035392', 'Pacífico S.A. EPS' => '20431115825', 'Fondo de Empleados de la SUNAT' => '204990030810', 'Rimac Seguros y Reaseguros' => '20100041953', 'Rimac S.A. Entidad Prestadora de Salud' => '20414955020'}
  end
  def delete
    p = PayDocument.find(params[:pay_document_id])
    a = p.authorization
    unless p.benefit.nil?
      b = p.benefit      
      if b.detail_services.exists?
        ds = b.detail_services
        ds.each do |dss|
          dss.destroy
        end
      end
      if b.detail_pharmacies.exists?
        dp = b.detail_pharmacies
        dp.each do |dps|
          dps.destroy
        end
      end
      ds = b.detail_services
      dp = b.detail_pharmacies        
      b.destroy
    end 
    p.destroy
    redirect_to show_authorization_path(id: a.id)
  end

  def print
    @pay_document = PayDocument.find(params[:id])
    @ruc = @pay_document.insurance_ruc
    @insured = @pay_document.authorization.patient.insured
    @detail_services = @pay_document.benefit.detail_services
    @void = 22 - @detail_services.count
    t = @pay_document.total_amount
    @words = to_words(t).upcase
    @decimal_words =("%.0f" % ((t.to_f - t.to_i).round(2)*100.to_i).to_s )
    @detail_pharmacies = @pay_document.benefit.detail_pharmacies
    @total_pharmacies = 0
    @liquidation_group = ''
    @pay_document.authorization.insured_pharmacies.each do |i|      
      @liquidation_group += '- ' + i.liquidation.to_s
    end
    @detail_pharmacies.each do |d|
      @total_pharmacies = @total_pharmacies.to_f + d.amount.to_f
    end
  end

  def new
  	@authorization = Authorization.find(params[:authorization_id])
  	@insured = Insured.find(params[:insured_id])
  end

  def ready
  	@pay_document = PayDocument.find(params[:pay_document_id])
    @pay_document_types = to_hash(PayDocumentType.all)
    @sub_mechanism_pay_types = to_hash(SubMechanismPayType.all.order(:name))
    @indicator_globals = to_hash(IndicatorGlobal.all)
    case @pay_document.authorization.patient.insured.insurance.id
      when 1,2,6
        @insurances = {'Pacífico Peruana Suiza CIA de Seguros' => '20100035392', 'Pacífico S.A. EPS' => '20431115825', 'Fondo de Empleados de la SUNAT' => '204990030810'}
      when 3,8,13        
        @insurances = {'Rimac Seguros y Reaseguros' => '20100041953', 'Rimac S.A. Entidad Prestadora de Salud' => '20414955020'}
    end   
  end

  def benefit    
    @document_types = to_hash(DocumentType.all)
    @benefit = Benefit.find(params[:benefit_id])
    @authorization = @benefit.pay_document.authorization
    
  end

  def get_code_ruc(ruc)
    case ruc
    #Pacífico
    when '20100035392'
      '40004'
    when '20431115825'
      '20002'
    when '20499030810'
      '30011'
    #Rimac
    when '20100041953'
      '40007'
    when '20414955020'
      #Buscar en documento de AND-PC
      '20001'
    end
  end

  def get_direction_ruc(ruc)
    case ruc
    when '20100035392'
      'Av. Juan de Arona Nº 830, Lima.'
    when '20431115825'
      'Av. Juan de Arona Nº 830, Lima.'
    when '20499030810'
      'Av. Arequipa 1295 dpto. 501, Lima.'
    when '20100041953'
      'Jr Capaccio Nº 296 San Borja.'
    when '20414955020'
      #Buscar en documento de AND-PC
      'Jr Capaccio Nº 296 San Borja.'
    end
  end
  def get_social_ruc(ruc)
    case ruc
    when '20100035392'
      'Pacífico Peruana Suiza CIA de Seguros.'
    when '20431115825'
      'Pacífico S.A. EPS.'
    when '20499030810'
      'Fondo de Empleados de la SUNAT.'
    when '20100041953'
      'Rimac Seguros y Reaseguros.'
    when '20414955020'
      #Buscar en documento de AND-PC
      'Rimac S.A. Entidad Prestadora de Salud.'
    end
  end

  def asign
    @doctors = to_hash_doctor(Doctor.all)
    @pay_document = PayDocument.find(params[:pay_document_id])
    @document_types = to_hash(DocumentType.all)
    @product_pharm_types = to_hash(ProductPharmType.all)
  end

  def to_hash_doctor(query)
    hash = Hash.new
    query.each do |q|
      hash[q.complet_name] = q.id
    end
    hash
  end
  
  def asigned
    @pay_document = PayDocument.find(params[:pay_document_id])
    @detail_services = @pay_document.benefit.detail_services
    @detail_pharmacies = @pay_document.benefit.detail_pharmacies
  end

  def update_amount
    p = PayDocument.find(params[:pay_document_id])
    p.net_amount = params[:net_amount]
    p.total_igv = p.net_amount.to_f*0.18
    p.total_amount = p.net_amount + p.total_igv
    p.save
    redirect_to ready_principal_facturation_path(pay_document_id: p.id)
  end

  def confirm
  	@authorization = Authorization.find(params[:authorization_id])
    p = PayDocument.create(authorization: @authorization)
    b = Benefit.create(pay_document: p)
    redirect_to ready_principal_facturation_path(pay_document_id: p.id)
  end

  def close_facture
    p = PayDocument.find(params[:pay_document_id])
    b = p.benefit
    b.document_code = p.code
    b.save
    b.detail_services.each do |ds|
      ds.payment_document = p.code
      ds.save
    end
    b.detail_pharmacies.each do |dp|
      dp.document_number = p.code
      dp.save
    end
    b.upgrade_data_sales
    redirect_to ready_principal_facturation_path(pay_document_id: b.pay_document.id)
  end

  def create_lot
    @insurances = {'Pacífico Peruana Suiza CIA de Seguros' => '20100035392', 'Pacífico S.A. EPS' => '20431115825', 'Fondo de Empleados de la SUNAT' => '204990030810', 'Rimac Seguros y Reaseguros' => '20100041953', 'Rimac S.A. Entidad Prestadora de Salud' => '20414955020'}
    @pay_document_groups = PayDocumentGroup.all
    if request.post?
      init_date = params[:init_date]
      end_date = params[:end_date]
      insurance_ruc = params[:insurance]
      @pay_documents = PayDocument.where("emission_date <= '" + end_date + "' and emission_date >= '"+ init_date + "' and is_closed = 1 and insurance_ruc = '"+insurance_ruc+"'")
      pg = PayDocumentGroup.create(quantity: @pay_documents.count)
      @pay_documents.each do |p|
        if p.pay_document_group.nil?
          p.pay_document_group_id = pg.id
        end        
        p.save
      end
      pg.print
      BenefitGroup.where(code: pg.code).last.print
      DetailServiceGroup.where(code: pg.code).last.print
      DetailPharmacyGroup.where(code: pg.code).last.print
    end
  end

  def delete_lot
    pg = PayDocumentGroup.where(code: params[:lot_code]).last
    bg = BenefitGroup.where(code: params[:lot_code]).last
    dsg = DetailServiceGroup.where(code: params[:lot_code]).last
    dpg = DetailPharmacyGroup.where(code: params[:lot_code]).last
    pg.pay_documents.each do |p|
      p.pay_document_group_id = nil
    end
    bg.benefits.each do |p|
      p.benefit_group_id = nil
    end    
    unless dsg.nil?
      unless dsg.detail_services.exists?
        dsg.detail_services.each do |p|
          p.detail_service_group_id = nil
        end
      end
    end
    unless dpg.nil?
      unless dpg.detail_pharmacies.exists?
        dpg.detail_pharmacies.each do |p|
          p.detail_pharmacy_group_id = nil
        end
      end
    end      
    pg.destroy
    bg.destroy
    unless dsg.nil?
      dsg.destroy
    end
    unless dpg.nil?
      dpg.destroy
    end   
    redirect_to create_lot_path
  end

  def generate_lot
    
  end

  def show

  end

  def update_principal
    p = PayDocument.find(params[:id])
    if !p.authorization.product.nil?
      p.product_code = p.authorization.product.code
    end
    p.code = params[:code]
    b = p.benefit
      b.document_code = p.code
      b.save
      b.detail_services.each do |ds|
        ds.payment_document = p.code
        ds.save
      end
      b.detail_pharmacies.each do |dp|
        dp.document_number = p.code
        dp.save
      end
    p.emission_date = params[:emission_date]
    p.insurance_ruc = params[:insurance]
    p.direction = get_direction_ruc(params[:insurance])
    p.social = get_social_ruc(params[:insurance])    
    p.insurance_code = get_code_ruc(params[:insurance])
    p.indicator_global_id = params[:indicator_global_id]
    p.indicator_global_code = IndicatorGlobal.find(p.indicator_global_id).code
    p.save
    redirect_to ready_principal_facturation_path(pay_document_id: p.id)
  end

  def update_benefit
    b = Benefit.find(params[:id])
    if !params[:document_type_id].nil?
      b.document_type_id = params[:document_type_id]
      code = DocumentType.find(params[:document_type_id]).code
      b.second_authorization_type = code
      b.second_authorization_code = params[:document_type_code]
    else
      b.document_type_id = 8
      b.second_authorization_type = DocumentType.find(8).code
    end
    b.document_identity_code = params[:document_identity_code].ljust(15, ' ')
    b.intern_code = params[:intern_code]
    b.clinic_history_code = params[:clinic_history_code]
    c = b.pay_document.authorization.coverage
    c.cop_var = params[:new_cop_var].to_s.rjust(12,' ')
    b.save
    c.save
    redirect_to ready_benefit_facturation_path(benefit_id: b.id)
  end

  def update_asign
    p = PayDocument.find(params[:id])
    p.sub_mechanism_pay_type_id = params[:sub_mechanism_pay_type_id]
    p.pay_document_type_id = params[:pay_document_type_id]
    p.indicator_global_id = params[:indicator_global_id]
    p.save
    redirect_to ready_principal_facturation_path(pay_document_id: p.id)
  end  

  def add_detail_service
    b = Benefit.find(params[:benefit_id])
    p = PurchaseInsuredService.find(params[:detail_service_id])
    p.is_facturated = true
    p.save
    i_service = p.insured_service
    pay = b.pay_document
    a = pay.authorization
    clinic_ruc = a.clinic.ruc
    clinic_code = a.clinic.code
    payment_type_document = '01'
    payment_document = pay.code
    clasification_service_type = '03'
    service_code = p.service.code
    date = p.insured_service.created_at.strftime("%Y-%m-%d")
    clasification_service_type_id = 3
    service_description = p.service.name
    professional_type = 'CM'
    doctor = Doctor.find(params[:doctor_id])
    tuition_code = doctor.tuition_code
    diagnostic_code = a.first_diagnostic
    exented_code = p.service_exented.code
    if b.detail_services.count == 0
      correlative = 1
    else
      order_benefit(b)
      correlative = b.detail_services.count + 1
    end
    correlative_benefit = 1
    sector_id = get_sector(p.service.contable_code)
    sector_code = Sector.find(sector_id).code
    if p.unitary_factor.nil? or p.unitary_factor == 0 or p.unitary_factor == ''
      unitary = p.unitary
    else
      unitary = p.unitary_factor       
    end    
    quantity = p.quantity
    copayment = p.copayment
    amount = (unitary * quantity).round(2)
    index = p.id
    if p.service.code = '50.01.01'
      has_consultation = true
    else
      has_consultation = nil
    end

    d = DetailService.create(benefit: b, clasification_service_type_id: 3, correlative: correlative, clinic_ruc: clinic_ruc, clinic_code: clinic_code,  payment_type_document: payment_type_document, payment_document: payment_document, clasification_service_type_code: '03', service_code: service_code, service_description: service_description, date: date, professional_type: professional_type, tuition_code: tuition_code, quantity: quantity, unitary: unitary, copayment: copayment, amount: amount, amount_not_covered: 0, diagnostic_code: diagnostic_code, exented_code: exented_code, sector_id: sector_id, sector_code: sector_code, correlative_benefit: correlative_benefit, index: index)
    
    redirect_to ready_asign_facturation_path(pay_document_id: pay.id)
  end

=begin
  select p.id, s.code, p.is_facturated from pay_documents pay
  inner join authorizations a on a.id = pay.authorization_id
  inner join insured_services ise on a.id = ise.authorization_id
  inner join purchase_insured_services p on ise.id = p.insured_service_id
  inner join services s on s.id = p.service_id
  where pay.code = '0001-0050462'

  select pay.code, de.id, de.service_code, `index` from detail_services de
  inner join benefits b on b.id = de.benefit_id
  inner join pay_documents pay on pay.id = b.pay_document_id
=end

  def get_sector(ca)
    case ca
    when '1'
      2
    when '2'
      13
    when '3'
      1
    when '4'
      4
    when '5'
      6
    when '9'
      16  
    end
  end

  def order_benefit(benefit)
    count = 1
    benefit.detail_services.each do |d|
      d.correlative = count
      d.save
      count = count + 1
    end

    count = 1
    benefit.detail_pharmacies.each do |d|
      d.correlative = count
      d.save
      count = count + 1
    end
  end


  def delete_detail_service
    d = DetailService.find(params[:detail_service_id])
    pay = Benefit.find(d.benefit_id).pay_document
    b = pay.benefit
    order_benefit(b)
    p = PurchaseInsuredService.find(d.index)
    p.is_facturated = nil
    p.save
    d.destroy
    redirect_to ready_asign_facturation_path(pay_document_id: pay.id)
  end

  def delete_detail_coverage
    d = DetailService.find(params[:detail_service_id])
    pay = Benefit.find(d.benefit_id).pay_document
    p = PurchaseCoverageService.find(d.index)
    order_benefit(pay.benefit)
    p.is_facturated = nil
    pay.has_consultation = nil
    pay.save
    p.save
    d.destroy
    redirect_to ready_asign_facturation_path(pay_document_id: pay.id)
  end

  def delete_detail_pharmacy
    d = DetailPharmacy.find(params[:detail_pharmacy_id])
    pay = Benefit.find(d.benefit_id).pay_document
    p = PurchaseInsuredPharmacy.find(d.index)
    p.is_facturated = nil
    p.save
    d.destroy
    redirect_to ready_asign_facturation_path(pay_document_id: pay.id)
  end

  def add_detail_pharmacy
    b = Benefit.find(params[:benefit_id])
    p = PurchaseInsuredPharmacy.find(params[:detail_pharmacy_id])
    p.is_facturated = true
    pay = b.pay_document
    a = pay.authorization
    clinic_ruc = a.clinic.ruc
    clinic_code = a.clinic.code
    payment_type_document = '01'
    payment_document = pay.code
    type_code = p.product_pharm_type.code
    sunasa_code = 'XXXXXXXXXXX'
    ean_code = 'XXXXXXXXXXXXX'
    if params[:product_pharm_type_id] != '1'
      digemid_code = ' '*6
    else
      digemid_code = p.digemid_product.code
    end    
    date = p.insured_pharmacy.created_at.strftime("%Y-%m-%d")
    diagnostic_code = a.first_diagnostic
    exented_code = p.product_pharm_exented.code
    if b.detail_pharmacies.count == 0
      correlative = 1
    else
      correlative = b.detail_pharmacies.count + 1
    end
    correlative_benefit = 1      
    unitary = p.unitary
    quantity = p.quantity
    copayment = p.copayment
    amount = (unitary * quantity).round(2)
    pharm_guide = (p.insured_pharmacy.id + 5000).to_s
    index = p.id
    d = DetailPharmacy.create(benefit: b, correlative: correlative, clinic_ruc: clinic_ruc, clinic_code: clinic_code,  document_type_code: payment_type_document, document_number: payment_document, correlative_benefit: correlative_benefit, type_code: type_code, sunasa_code: sunasa_code, ean_code: ean_code, digemid_code: digemid_code, date: date, quantity: quantity, unitary: unitary, copayment: copayment, amount: amount, amount_not_covered: 0, diagnostic_code: diagnostic_code, exented_code: exented_code, pharm_guide: pharm_guide, index: index)
    p.save
    redirect_to ready_asign_facturation_path(pay_document_id: pay.id)
  end

  def add_detail_coverage
    b = Benefit.find(params[:benefit_id])
    p = PurchaseCoverageService.find(params[:detail_service_id])
    
    p.is_facturated = true
    p.save
    #Hola...  te voy a llamar apenas pueda, estoy muyapenado y aun no termino de comprender que paso anoche.. solo quiero saber como estas :/
    i_service = p.insured_service
    pay = b.pay_document
    a = pay.authorization
    clinic_ruc = a.clinic.ruc
    clinic_code = a.clinic.code
    payment_type_document = '01'
    payment_document = pay.code
    clasification_service_type = '03'
    service_code = p.service.code
    date = p.insured_service.created_at.strftime("%Y-%m-%d")
    clasification_service_type_id = 3
    service_description = p.service.name
    professional_type = 'CM'
    tuition_code = a.doctor.tuition_code
    diagnostic_code = a.first_diagnostic
    exented_code = 'A'
    if b.detail_services.count == 0
      correlative = 1
    else
      order_benefit(b)
      correlative = b.detail_services.count + 1
    end
    correlative_benefit = 1
    sector_id = 2
    sector_code = '02'     
    unitary = p.unitary
    quantity = 1
    copayment = p.copayment
    amount = (unitary * quantity).round(2)
    index = p.id
    d = DetailService.create(benefit: b, clasification_service_type_id: 3, correlative: correlative, clinic_ruc: clinic_ruc, clinic_code: clinic_code,  payment_type_document: payment_type_document, payment_document: payment_document, clasification_service_type_code: '03', service_code: service_code, service_description: service_description, date: date, professional_type: professional_type, tuition_code: tuition_code, quantity: quantity, unitary: unitary, copayment: copayment, amount: amount, amount_not_covered: 0, diagnostic_code: diagnostic_code, exented_code: exented_code, sector_id: sector_id, sector_code: sector_code, correlative_benefit: correlative_benefit, index: index)
    p = d.benefit.pay_document
    p.has_consultation = true
    p.save
    redirect_to ready_asign_facturation_path(pay_document_id: pay.id)
  end
end
