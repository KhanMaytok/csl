class FacturationsController < ApplicationController
  before_action :block_unloged
  def index
  	@authorizations = Authorization.order(date: :desc).paginate(:page => params[:page])
  end

  def list
    @pay_documents = PayDocument.all.where(is_closed: true).order(date: :desc).paginate(:page => params[:page])
  end

  def print
    @pay_document = PayDocument.find(params[:id])
    @insurance = @pay_document.authorization.patient.insured.insurance
    @insured = @pay_document.authorization.patient.insured
    @detail_services = @pay_document.benefit.detail_services
    @detail_pharmacies = @pay_document.benefit.detail_pharmacies
    @total_pharmacies = 0
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
    @pay_document = PayDocument.find(params[:pay_document_id])
    @document_types = to_hash(DocumentType.all)
  end
  
  def asigned
    @pay_document = PayDocument.find(params[:pay_document_id])
    @detail_services = @pay_document.benefit.detail_services
    @detail_pharmacies = @pay_document.benefit.detail_pharmacies
  end

  def confirm
  	@authorization = Authorization.find(params[:authorization_id])
    p = PayDocument.create(authorization: @authorization)
    b = Benefit.create(pay_document: p)
    redirect_to ready_principal_facturation_path(pay_document_id: p.id)
  end

  def close_facture
    b = PayDocument.find(params[:pay_document_id]).benefit
    b.upgrade_data_sales
    redirect_to ready_principal_facturation_path(pay_document_id: b.pay_document.id)
  end

  def create_lot
    if request.post?
      init_date = params[:init_date]
      end_date = params[:end_date]
      @pay_documents = PayDocument.where("emission_date <= '" + end_date + "' and emission_date >= '"+ init_date + "' and is_closed = 1")
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

  def generate_lot
    
  end

  def show

  end

  def update_principal
    p = PayDocument.find(params[:id])
    if !p.authorization.product.nil?
      p.product_code = p.authorization.product.code
    end
    p.insurance_ruc = params[:insurance]
    p.direction = get_direction_ruc(params[:insurance])
    p.social = get_social_ruc(params[:insurance])
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
    tuition_code = a.doctor.tuition_code
    diagnostic_code = a.first_diagnostic
    exented_code = p.service_exented.code
    if b.detail_services.count == 0
      correlative = 1
    else
      correlative = b.detail_services.count + 1
    end
    correlative_benefit = 1
    sector_id = get_sector(p.service.clinic_area_id)
    sector_code = Sector.find(sector_id).code        
    unitary = p.unitary_factor
    quantity = p.quantity
    copayment = p.copayment
    amount = (unitary * quantity).round(2)
    index = p.id
    d = DetailService.create(benefit: b, clasification_service_type_id: 3, correlative: correlative, clinic_ruc: clinic_ruc, clinic_code: clinic_code,  payment_type_document: payment_type_document, payment_document: payment_document, clasification_service_type_code: '03', service_code: service_code, service_description: service_description, date: date, professional_type: professional_type, tuition_code: tuition_code, quantity: quantity, unitary: unitary, copayment: copayment, amount: amount, amount_not_covered: 0, diagnostic_code: diagnostic_code, exented_code: exented_code, sector_id: sector_id, sector_code: sector_code, correlative_benefit: correlative_benefit, index: index)
    redirect_to ready_asign_facturation_path(pay_document_id: pay.id)
  end

  def delete_detail_service
    d = DetailService.find(params[:detail_service_id])
    pay = Benefit.find(d.benefit_id).pay_document
    p = PurchaseInsuredService.find(d.index)
    p.is_facturated = nil
    p.save
    d.destroy
    redirect_to ready_asign_facturation_path(pay_document_id: pay.id)
  end

  def delete_detail_coverage
    d = DetailService.find(params[:detail_service_id])
    pay = Benefit.find(d.benefit_id).pay_document
    p = PurchaseCoverageServices.find(d.index)
    p.is_facturated = nil
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
    p.save
    pay = b.pay_document
    a = pay.authorization
    clinic_ruc = a.clinic.ruc
    clinic_code = a.clinic.code
    payment_type_document = '01'
    payment_document = pay.code
    type_code = p.product_pharm_type.code
    sunasa_code = 'XXXXXXXXXXX'
    ean_code = 'XXXXXXXXXXXXX'
    digemid_code = p.digemid_product.code
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
    redirect_to ready_asign_facturation_path(pay_document_id: pay.id)
  end


  def get_sector(ca)
    case ca
    when 1
      3
    when 2
      3
    when 3
      3
    when 4
      4
    when 5
      6
    when 6
      10
    when 7
      10
    when 8
      13      
    end
  end
end
