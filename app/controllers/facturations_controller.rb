class FacturationsController < ApplicationController
  respond_to :html, :js
  @@lotes_path = '/home/fabian/facturacion/Lotes/'
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

  def export_pdf
    id = params[:id]
    kit = PDFKit.new('http://www.facebook.com')
    kit.to_file(Rails.root + 'holi34.pdf')
    redirect_to root_path
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
    unless params[:anotation].nil?
      @pay_documents = PayDocument.where('is_closed = true and anotation like "%'+params[:anotation].to_s+'%"').order(id: :desc).paginate(:page => params[:page])
    end

    @insurances = {'Pacífico Peruana Suiza CIA de Seguros' => '20100035392', 'Pacífico S.A. EPS' => '20431115825', 'Fondo de Empleados de la SUNAT' => '20499030810', 'Rimac Seguros y Reaseguros' => '20100041953', 'Rimac S.A. Entidad Prestadora de Salud' => '20414955020'}

    respond_to do |format|
      format.js
      format.html
    end
  end

  def fix
    p = PurchaseInsuredPharmacy.find(params[:purchase_insured_pharmacy_id])
    p.is_facturated = nil
    p.save
    redirect_to ready_asign_facturation_path(pay_document_id: params[:pay_document_id])
  end

  def fix_service
    p = PurchaseInsuredService.find(params[:purchase_insured_service_id])
    p.is_facturated = nil
    p.save
    redirect_to ready_asign_facturation_path(pay_document_id: params[:pay_document_id])
  end

  def fix_facturated
    d = DetailService.find(params[:detail_service_id])
    d.destroy
    redirect_to ready_asigned_facturation_path(pay_document_id: params[:pay_document_id])
  end

  def delete
    p = PayDocument.find(params[:pay_document_id])
    a = p.authorization
    unless p.benefit.nil?
      b = p.benefit      
      if b.detail_services.exists?
        ds = b.detail_services
        ds.each do |dss|
          if dss.purchase_code == 'C'
            if PurchaseCoverageService.where(id: dss.index).exists?         
              p = PurchaseCoverageService.find(dss.index)
              p.is_facturated = nil
              p.save
            end
          else
            if dss.purchase_code == 'S'
              p = PurchaseInsuredService.find(dss.index)
              p.is_facturated = nil
              p.save
            end
          end
          dss.destroy
        end
      end
      if b.detail_pharmacies.exists?
        dp = b.detail_pharmacies
        dp.each do |dps|
          p = PurchaseInsuredPharmacy.find(dps.index)
          p.is_facturated = nil
          p.save
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
    @void = 19 - @detail_services.count
    t = @pay_document.total_amount
    @words = to_words(t).upcase
    @decimal_words =("%.0f" % ((t.to_f - t.to_i).round(2)*100.to_i).to_s )
    @detail_pharmacies = @pay_document.benefit.detail_pharmacies
    @total_pharmacies = 0
    @liquidation_group = @pay_document.liquidation_string
    @detail_pharmacies.each do |d|
      @total_pharmacies = @total_pharmacies.to_f + d.amount.to_f
    end
  end


  def new
    @authorization = Authorization.find(params[:authorization_id])
    @insured = Insured.find(params[:insured_id])

  end

  def ready
    @statuses = {'N' => 'Correcta', 'R' => 'Refacturada', 'D' => 'Anulada'}
    @pay_document = PayDocument.find(params[:pay_document_id])
    @pay_document_types = to_hash(PayDocumentType.all)
    @sub_mechanism_pay_types = to_hash(SubMechanismPayType.all.order(:name))
    @indicator_globals = to_hash(IndicatorGlobal.all)
    @products = to_hash_product(Product.all.order(:name))
    case @pay_document.authorization.patient.insured.insurance.id
    when 1,2,6
      @insurances = {'Pacífico Peruana Suiza CIA de Seguros' => '20100035392', 'Pacífico S.A. EPS' => '20431115825', 'Fondo de Empleados de la SUNAT' => '20499030810','Rimac Seguros y Reaseguros' => '20100041953', 'Rimac S.A. Entidad Prestadora de Salud' => '20414955020'}
    when 3,8,13,10
      @insurances = {'Pacífico Peruana Suiza CIA de Seguros' => '20100035392', 'Pacífico S.A. EPS' => '20431115825', 'Fondo de Empleados de la SUNAT' => '20499030810','Rimac Seguros y Reaseguros' => '20100041953', 'Rimac S.A. Entidad Prestadora de Salud' => '20414955020'}
    else
      @insurances = {'Seguro Integral de Salud' => '20505208626', 'Mapfre Perú S.A. Entidad Prestadora de Salud' => '20517182673', 'Mapfre Perú Cía de Seguros y Reaseguros' => '20202380621', 'La Positiva Sanitas S.A. EPS' => '20523470761', 'La Positiva Seguros y Reaseguros' => '20100210909'}
    end
  end

  def to_hash_product(query)
    hash = Hash.new
    query.each do |q|
      hash[q.name] = q.code
    end
    hash
  end

  def benefit
    @hospitalization_types = to_hash_hosp_in(HospitalizationType.all)
    @hospitalization_output_types = to_hash_hosp_out(HospitalizationOutputType.all)
    @document_types = to_hash_document_type(DocumentType.all)
    @companies = to_hash(Company.order(:name))
    @benefit = PayDocument.find(params[:pay_document_id]).benefit
    @pay_document = PayDocument.find(params[:pay_document_id])
    @authorization = @benefit.pay_document.authorization
    @afiliation_types = to_hash_afiliation(AfiliationType.all)
    @sub_coverage_types = to_hash_sub(SubCoverageType.all.order(:name))
    @product_codes = { 'ADMI' => 'ADMI', 'AM05' => 'AM05', 'FOLA' => 'FOLA', 'MINT' => 'MINT', 'MNAC' => 'MNAC', 'MPLN' => 'MPLN', 'MSLD' => 'MSLD', 'SEAU' => 'SEAU', 'SECO' => 'SECO',  }
  end

  def to_hash_document_type(query)
    hash = Hash.new
    query.each do |q|
      hash[q.name + ' - ' + q.code] = q.id
    end
    hash
  end

  def to_hash_afiliation(query)
    hash = Hash.new
    query.each do |q|
      hash[q.name] = q.fac_code
    end
    hash
  end

  def to_hash_sub(query)
    hash = Hash.new
    query.each do |q|
      hash[q.name + ' ' +  q.fact_code + ' - ' + q.code + ' - ' + q.other_code + ' - ' + q.coverage_type.code] = q.id
    end
    hash
  end

  def get_code_ruc(ruc)
    case ruc
    when '20100035392'
      '40003'
    when '20431115825'
      '20002'
    when '20499030810'
      '30011'
    when '20100041953'
      '40007'
    when '20414955020'
      '20001'
    when '20517182673'
      '20004'
    when '20202380621'
      '40006'
    when '20523470761'
      '20005'
    when '20100210909'
      '40005'
    when '20505208626'
      '10001'
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
      'Jr Carpaccio Nº 296 San Borja.'
    when '20414955020'
      'Jr Carpaccio Nº 296 San Borja.'
    when '20517182673'
      'Av 28 de julio Nº 873 Miraflores'
    when '20202380621'
      'Av 28 de julio Nº 873 Miraflores'
    when '20523470761'
      'Av José Pardo Nº 899 Miraflores'
    when '20100210909'
      'Av. Cutervo Oeste Nº 144'
    when '20505208626'
      'CAL. CARLOS GONZALES NRO. 212 LIMA - LIMA - SAN MIGUEL'
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
      'Rimac S.A. Entidad Prestadora de Salud.'
    when '20517182673'
      'Mapfre Perú S.A. Entidad Prestadora de Salud.'
    when '20202380621'
      'Mapfre Perú Cía de Seguros y Reaseguros'
    when '20523470761'
      'La Positiva Sanitas S.A. EPS'
    when '20100210909'
      'La Positiva Seguros y Reaseguros'
    when '20505208626'
      'Seguro Integral de Salud'
    end
  end

  def asign
    @doctors = to_hash_doctor(Doctor.all)
    @pay_document = PayDocument.find(params[:pay_document_id])
    @document_types = to_hash(DocumentType.all)
    @product_pharm_types = to_hash(ProductPharmType.all)
    @providers_lab = to_hash(Provider.all)
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
    p.total_cop_fijo = params[:cop_fijo]
    p.benefit.cop_fijo = params[:cop_fijo]
    p.total_cop_var = params[:cop_var]
    p.benefit.cop_var = params[:cop_var]
    total = p.benefit.total_expense
    p.net_amount = (total - (p.total_cop_var + p.total_cop_fijo)).round(2)
    p.total_igv = (p.net_amount.to_f*0.18).round(2)
    p.total_amount = p.net_amount.round(2) + p.total_igv.round(2)
    p.save
    p.benefit.save
    redirect_to ready_principal_facturation_path(pay_document_id: p.id)
  end

  def confirm
    @authorization = Authorization.find(params[:authorization_id])
    p = PayDocument.create(created_at: Time.now, authorization: @authorization, employee_id: current_employee.id)
    b = Benefit.create(created_at: Time.now, pay_document: p)
    redirect_to ready_principal_facturation_path(pay_document_id: p.id)
  end

  def close_facture
    p = PayDocument.find(params[:pay_document_id])
    b = p.benefit
    p.set_code_to_details
    b.upgrade_data_sales
    redirect_to ready_principal_facturation_path(pay_document_id: b.pay_document.id)
  end

  def providers

  end

  def export_lot
    p_group = PayDocumentGroup.find(params[:pay_document_group_id])
    lot = p_group.code
    unless params[:flag] == '1'
      row_1 = ['', '', p_group.pay_documents.last.social]
    else
      row_1 = ['', 'Lote Nº '+lot, p_group.pay_documents.last.social]
    end
    if File.exist?('/home/fabian/facturacion/Lotes/'+'/lot_'+p_group.code.to_s+'.xlsx')
      File.chmod(0777, '/home/fabian/facturacion/Lotes/'+'/lot_'+p_group.code.to_s+'.xlsx')
      File.delete('/home/fabian/facturacion/Lotes/'+'/lot_'+p_group.code.to_s+'.xlsx')
    end

    header = ['', 'Nº de Factura', 'Fecha de emisión', 'Nº de Autorización', 'Asegurado', 'Monto']
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Pago a proveedores") do |sheet|
        sheet.add_row row_1, style: sheet.styles.add_style(:bg_color => "9AEDF0", :fg_color=>"#FF000000", :sz=>14,  :border=> {:style => :thin, :color => "FFFF0000"})
        sheet.add_row [' ']
        sheet.add_row header
        p_group.pay_documents.order(:code).each do |p|
          sheet.add_row ['', p.code, p.emission_date, p.authorization.code, to_name_i(p.authorization.patient), p.total_amount]
        end
      end
      p.serialize(@@lotes_path+'/lot_'+p_group.code.to_s+'.xlsx')
    end
    redirect_to create_lot_path(page: '1')
  end

  def export
    init_date = params[:init_date]
    end_date = params[:end_date]
    
    if File.exist?(@@lotes_path+'/export_'+init_date.to_s+'_'+end_date.to_s+'.xlsx')
      File.chmod(0777, @@lotes_path+'/export_'+init_date.to_s+'_'+end_date.to_s+'.xlsx')
      File.delete(@@lotes_path+'/export_'+init_date.to_s+'_'+end_date.to_s+'.xlsx')
    end
    header = ['MÉDICO/PROVEEDOR', 'Nº AUTORIZACIÓN', 'FECHA Y HORA AUTORIZACIÓN', 'FECHA FACTURA', 'Nº FACTURA', 'ASEGURADORA', 'EMPRESA', 'ASEGURADO', 'CONCEPTO', 'PROVEEDOR', 'FACTOR', 'CANTIDAD', 'PRECIO UNITARIO', 'VALOR DE VENTA', ' ', ' ', ' ', ' ', 'ESTADO']
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Pago a proveedores") do |sheet|
        sheet.add_row header , style: sheet.styles.add_style(:bg_color => "9AEDF0", :fg_color=>"#FF000000", :sz=>14,  :border=> {:style => :thin, :color => "FFFF0000"})
        DetailService.joins(benefit: :pay_document).where("pay_documents.emission_date <= '" + end_date + "' and pay_documents.emission_date >= '"+ init_date + "' and is_closed = 1 and pay_documents.code <> '0001-0000000'").each do |d|
          doctor = Doctor.find_by_tuition_code(d.tuition_code).complet_name
          provider = d.observation
          if d.service_code == '33.01.07'
            provider = 'Clínica'
          end
          authorization_code = d.benefit.pay_document.authorization.code
          authorization_date = d.benefit.pay_document.authorization.date.strftime("%d/%m/%Y"+' '+"%H:%M:%S")
          pay_document_date = d.benefit.pay_document.emission_date.strftime("%d/%m/%Y")
          pay_document_code = d.benefit.pay_document.code
          insured = to_name_i(d.benefit.pay_document.authorization.patient)
          company = d.benefit.pay_document.authorization.patient.insured.company.name
          insurance = d.benefit.pay_document.social
          if insurance == '' or insurance.nil?
            insurance = get_social_ruc(d.benefit.pay_document.insurance_ruc)
          end
          quantity = d.quantity
          amount = "%.2f" % d.amount.round(2)
          if d.purchase_code == 'C'
            concept = PurchaseCoverageService.find(d.index).service.name
            factor = 1
            unitary = "%.2f" % d.unitary
            unless PurchaseCoverageService.find(d.index).insured_service.doctor.nil?
              provider = provider.to_s + ' ' + PurchaseCoverageService.find(d.index).insured_service.doctor.complet_name
            end
          else
            if PurchaseInsuredService.find(d.index).insured_service.clinic_area_id == 6 or d.observation.to_s.start_with?("AD")
              doctor = 'ADMINSA'
              provider = provider.to_s + ' ' + PurchaseInsuredService.find(d.index).insured_service.doctor.complet_name.to_s
            end
            provider = provider.to_s + ' ' + PurchaseInsuredService.find(d.index).insured_service.doctor.complet_name.to_s
            unless PurchaseInsuredService.find(d.index).service.nil?
              concept = PurchaseInsuredService.find(d.index).service.name
            end
            if PurchaseInsuredService.find(d.index).service.nil?
              factor = Factor.where(clinic_area_id: 1, insurance: d.benefit.pay_document.authorization.patient.insured.insurance).last.factor
            unitary = (amount.to_f/quantity.to_f).round(2)
            else
              factor = Factor.where(clinic_area: PurchaseInsuredService.find(d.index).service.clinic_area, insurance: d.benefit.pay_document.authorization.patient.insured.insurance).last.factor
            unitary = (amount.to_f/quantity.to_f).round(2)             
            end
          end          
          case d.benefit.pay_document.status
          when 'N'
            status = 'Facturado'
          when 'R'
            status = 'Refacturado'
          else
            status = 'Facturado'
          end  
          sheet.add_row [doctor, authorization_code,authorization_date, pay_document_date, pay_document_code,insurance ,company, insured, concept, provider, factor, quantity, unitary.to_f/factor.to_f, amount, ' ', ' ', ' ', ' ', status] , style: sheet.styles.add_style(:fg_color=>"#FF000000", :sz=>10,  :border=> {:style => :thin, :color => "#00000000"})
        end
        liquidations = Array.new
        DetailPharmacy.joins(benefit: :pay_document).where("detail_pharmacies.type_code <> 'I' and pay_documents.emission_date <= '" + end_date + "' and pay_documents.emission_date >= '"+ init_date + "' and is_closed = 1 ").each do |d|
          if PurchaseInsuredPharmacy.where(id: d.index).exists?
            pu = PurchaseInsuredPharmacy.find(d.index)
            unless liquidations.include?(pu.insured_pharmacy)
              if pu.product_pharm_type_id != 3
                liquidations.push(pu.insured_pharmacy)              
              end
            end
          end          
        end
        liquidations.each do |i|
          if i.pharm_type_sale_id == 1
            doctor = 'Clínica'
          else
            doctor = 'Grupo Ramco'
          end
          authorization_code = i.authorization.code
          authorization_date = i.authorization.date.strftime("%d/%m/%Y"+' '+"%H:%M:%S")
          pay_document_date = i.authorization.pay_documents.last.emission_date.strftime("%d/%m/%Y")
          pay_document_code = i.authorization.pay_documents.last.code
          insured = to_name_i(i.authorization.patient)
          company = i.authorization.patient.insured.company.name
          insurance = i.authorization.pay_documents.last.social
          if insurance == '' or insurance.nil?
            insurance = get_social_ruc(i.authorization.pay_documents.last.insurance_ruc)
          end
          quantity = 1
          amount = "%.2f" % i.initial_amount.to_f
          concept = i.liquidation
          factor = '1'
          unitary = "%.2f" % i.initial_amount.to_f
          unless DetailPharmacy.find_by_index(i.purchase_insured_pharmacies.last.id).nil?
            case DetailPharmacy.find_by_index(i.purchase_insured_pharmacies.last.id).benefit.pay_document.status
            when 'N'
              status = 'Facturado'
            when 'R'
              status = 'Refacturado'
            else
              status = 'Facturado'
            end  
          end
          sheet.add_row [doctor, authorization_code,authorization_date, pay_document_date, pay_document_code,insurance ,company, insured, concept, doctor, factor, quantity, unitary, amount, ' ', ' ', ' ', ' ', status] , style: sheet.styles.add_style(:fg_color=>"#FF000000", :sz=>10,  :border=> {:style => :thin, :color => "#00000000"})
        end
      end
      p.serialize(@@lotes_path+'/export_'+init_date.to_s+'_'+end_date.to_s+'.xlsx')
    end
    redirect_to facturation_providers_path
  end

  def create_lot
    @insurances = {'Seguro Integral de Salud' => '20505208626', 'Pacífico Peruana Suiza CIA de Seguros' => '20100035392', 'Pacífico S.A. EPS' => '20431115825', 'Fondo de Empleados de la SUNAT' => '20499030810', 'Rimac Seguros y Reaseguros' => '20100041953', 'Rimac S.A. Entidad Prestadora de Salud' => '20414955020'}
    @pay_document_groups = PayDocumentGroup.all.order(code: :desc).paginate(page: params[:page])
  end

  def delete_lot
    pg = PayDocumentGroup.where(code: params[:lot_code]).last
    bg = BenefitGroup.where(code: params[:lot_code]).last
    dsg = DetailServiceGroup.where(code: params[:lot_code]).last
    dpg = DetailPharmacyGroup.where(code: params[:lot_code]).last
    ddg = nil
    unless DetailDentalGroup.where(code: params[:lot_code]).last.nil?
      ddg = DetailDentalGroup.where(code: params[:lot_code]).last
    end
    pg.pay_documents.each do |p|
      p.pay_document_group_id = nil
    end
    FileUtils.rm_rf(@@lotes_path+pg.code)
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
    unless ddg.nil?
      unless ddg.detail_dentals.exists?
        ddg.detail_dentals.each do |p|
          p.detail_dental_group_id = nil
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
    unless ddg.nil?
      ddg.destroy
    end   
    redirect_to create_lot_path(page: '1')
  end

  def generate_lot
    if request.post?
      init_date = params[:init_date]
      end_date = params[:end_date]
      insurance_ruc = params[:insurance]
      if PayDocumentGroup.where(code: params[:lot_code]).exists?
        pg = PayDocumentGroup.where(code: params[:lot_code]).last
        bg = BenefitGroup.where(code: params[:lot_code]).last
        dsg = DetailServiceGroup.where(code: params[:lot_code]).last
        dpg = DetailPharmacyGroup.where(code: params[:lot_code]).last
        pg.pay_documents.each do |p|
          p.pay_document_group_id = nil
        end
        FileUtils.rm_rf(@@lotes_path+pg.code)
        bg.benefits.each do |p|
          p.benefit_group_id = nil
          p.save
        end    
        unless dsg.nil?
          unless dsg.detail_services.exists?
            dsg.detail_services.each do |p|
              p.detail_service_group_id = nil
              p.save
            end
          end
        end
        unless dpg.nil?
          unless dpg.detail_pharmacies.exists?
            dpg.detail_pharmacies.each do |p|
              p.detail_pharmacy_group_id = nil
              p.save
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
      end
      @pay_documents = PayDocument.where("emission_date <= '" + end_date + "' and emission_date >= '"+ init_date + "' and is_closed = 1 and insurance_ruc = '"+insurance_ruc+"'")
      unless params[:lot_code].nil? or params[:lot_code] == ''
        pg = PayDocumentGroup.create(code: params[:lot_code], quantity: @pay_documents.count, init_date: init_date, end_date: end_date, insurance_ruc: insurance_ruc)
      else
        pg = PayDocumentGroup.create(quantity: @pay_documents.count, init_date: init_date, end_date: end_date, insurance_ruc: insurance_ruc)
      end      
      @pay_documents.each do |p|
        p.pay_document_group_id = pg.id
        p.save
      end
      pg.print
      BenefitGroup.where(code: pg.code).last.print
      DetailServiceGroup.where(code: pg.code).last.print
      DetailPharmacyGroup.where(code: pg.code).last.print
      if DetailDentalGroup.where(code: pg.code).last.nil?
        DetailDentalGroup.create(code: pg.code)
      end
      DetailDentalGroup.where(code: pg.code).last.print
    end
    redirect_to create_lot_path(page: '1')
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
    p.status = params[:status]
    p.product_code = params[:product_code]
    p.credit_note = params[:credit_note]
    p.anotation = params[:anotation]
    p.emission_date = params[:emission_date]
    p.insurance_ruc = params[:insurance]
    p.direction = get_direction_ruc(params[:insurance])
    p.social = get_social_ruc(params[:insurance])    
    p.insurance_code = get_code_ruc(params[:insurance])
    p.indicator_global_id = params[:indicator_global_id]
    p.indicator_global_code = IndicatorGlobal.find(p.indicator_global_id).code
    p.save
    @statuses = {'N' => 'Correcta', 'R' => 'Refacturada', 'D' => 'Anulada'}
    @pay_document = PayDocument.find(p.id)
    @pay_document_types = to_hash(PayDocumentType.all)
    @sub_mechanism_pay_types = to_hash(SubMechanismPayType.all.order(:name))
    @indicator_globals = to_hash(IndicatorGlobal.all)
    @products = to_hash_product(Product.all.order(:name))
    case @pay_document.authorization.patient.insured.insurance.id
    when 1,2,6
      @insurances = {'Pacífico Peruana Suiza CIA de Seguros' => '20100035392', 'Pacífico S.A. EPS' => '20431115825', 'Fondo de Empleados de la SUNAT' => '20499030810','Rimac Seguros y Reaseguros' => '20100041953', 'Rimac S.A. Entidad Prestadora de Salud' => '20414955020'}
    when 3,8,13        
      @insurances = {'Pacífico Peruana Suiza CIA de Seguros' => '20100035392', 'Pacífico S.A. EPS' => '20431115825', 'Fondo de Empleados de la SUNAT' => '20499030810','Rimac Seguros y Reaseguros' => '20100041953', 'Rimac S.A. Entidad Prestadora de Salud' => '20414955020'}
    else
      @insurances = {'Seguro Integral de Salud' => '20505208626', 'Mapfre Perú S.A. Entidad Prestadora de Salud' => '20517182673', 'Mapfre Perú Cía de Seguros y Reaseguros' => '20202380621', 'La Positiva Sanitas S.A. EPS' => '20523470761', 'La Positiva Seguros y Reaseguros' => '20100210909'}
    end
    respond_to do |format|
      format.js
    end
  end

  def to_hash_hosp_in(query)
    hash = Hash.new
    query.each do |q|
      hash[q.name] = q.code
    end
    hash
  end

  def to_hash_hosp_out(query)
    hash = Hash.new
    query.each do |q|
      hash[q.name] = q.code
    end
    hash
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
    b.insured_code = params[:insured_code]
    b.first_authorization_number = params[:first_authorization_number]
    b.first_authorization_type = DocumentType.find(params[:first_authorization_type]).code
    b.date = params[:date]
    b.tuition_code = params[:tuition_code]
    b.sub_type_coverage_code = SubCoverageType.find(params[:sub_type_coverage_id]).fact_code
    coverage = SubCoverageType.find(params[:sub_type_coverage_id]).coverage_type
    b.coverage_type_code = coverage.code
    b.first_diagnostic = params[:first_diagnostic]
    b.detail_services.each do |d|
      d.diagnostic_code = b.first_diagnostic
      d.save
    end
    b.detail_pharmacies.each do |d|
      d.diagnostic_code = b.first_diagnostic
      d.save
    end
    if params[:hospitalization_type_code].nil? or params[:hospitalization_type_code] == ''
      b.hospitalization_type_code = nil
    else
      b.hospitalization_type_code = params[:hospitalization_type_code]
    end

    if params[:hospitalization_output_type_code].nil? or params[:hospitalization_output_type_code] == ''
      b.hospitalization_output_type_code = nil
    else
      b.hospitalization_output_type_code = params[:hospitalization_output_type_code]
    end
    b.admission_date = params[:admission_date]
    b.discharge_date = params[:discharge_date]
    b.days_hospitalization = params[:days_hospitalization]
    b.second_diagnostic = params[:second_diagnostic]
    b.third_diagnostic = params[:third_diagnostic]
    b.professional_identity_code = params[:professional_identity_code]
    b.afiliation_type_code = params[:afiliation_type_code]
    b.document_identity_code = params[:document_identity_code]
    b.intern_code = params[:intern_code]
    b.clinic_history_code = params[:clinic_history_code]
    a = b.pay_document.authorization
    a.product_code = params[:product_code]
    a.save
    b.save
    i = b.pay_document.authorization.patient.insured
    i.company_id = params[:company_id]
    i.save
    redirect_to ready_benefit_facturation_path(pay_document_id: b.pay_document.id)
  end

  def update_asign
    p = PayDocument.find(params[:id])
    p.sub_mechanism_pay_type_id = params[:sub_mechanism_pay_type_id]
    p.pay_document_type_id = params[:pay_document_type_id]
    p.indicator_global_id = params[:indicator_global_id]
    p.save
    redirect_to ready_principal_facturation_path(pay_document_id: p.id)
  end  

  def asign_all
    b = Benefit.find(params[:benefit_id])
    a = b.pay_document.authorization
    pay = b.pay_document
    a.insured_services.each do |i|
      if i.is_consultation
        PurchaseCoverageService.where(is_facturated: nil, insured_service_id: i.id).each do |p|
          p.is_facturated = true
          i_service = p.insured_service
          pay = b.pay_document
          a = pay.authorization
          type_purchase = 'C'
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
          unitary = p.initial_amount / p.quantity
          quantity = 1
          copayment = p.copayment
          amount = (unitary * quantity)
          index = p.id
          d = DetailService.create(:purchase_code => 'C', benefit: b, clasification_service_type_id: 3, correlative: correlative, clinic_ruc: clinic_ruc, clinic_code: clinic_code,  payment_type_document: payment_type_document, payment_document: payment_document, clasification_service_type_code: '03', service_code: service_code, service_description: service_description, date: date, professional_type: professional_type, tuition_code: tuition_code, quantity: quantity, unitary: unitary, copayment: copayment, amount: amount, amount_not_covered: 0, diagnostic_code: diagnostic_code, exented_code: exented_code, sector_id: sector_id, sector_code: sector_code, correlative_benefit: correlative_benefit, index: index)

          pay = d.benefit.pay_document
          pay.has_consultation = true
          pay.save
          p.save
        end
      else
        i.purchase_insured_services.where(is_facturated: nil).each do |p|
          p.is_facturated = true
          i_service = p.insured_service
          pay = b.pay_document
          a = pay.authorization
          type_purchase = 'S'
          insurance = a.patient.insured.insurance
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
          doctor = p.insured_service.doctor
          tuition_code = doctor.tuition_code
          diagnostic_code = a.first_diagnostic
          exented_code = p.service_exented.code
          observation = nil 
          if b.detail_services.count == 0
            correlative = 1
          else
            order_benefit(b)
            correlative = b.detail_services.count + 1
          end
          correlative_benefit = 1
          sector_id = get_sector(p.service.contable_code)
          sector_code = Sector.find(sector_id).code
          unitary = p.unitary_factor
          quantity = p.quantity
          copayment = p.copayment
          amount = (unitary * quantity).round(2)
          index = p.id
          d = DetailService.create(observation: observation, purchase_code: 'S', benefit: b, clasification_service_type_id: 3, correlative: correlative, clinic_ruc: clinic_ruc, clinic_code: clinic_code,  payment_type_document: payment_type_document, payment_document: payment_document, clasification_service_type_code: '03', service_code: service_code, service_description: service_description, date: date, professional_type: professional_type, tuition_code: tuition_code, quantity: quantity, unitary: unitary, copayment: copayment, amount: amount, amount_not_covered: 0, diagnostic_code: diagnostic_code, exented_code: exented_code, sector_id: sector_id, sector_code: sector_code, correlative_benefit: correlative_benefit, index: index)
          p.save
        end
      end
    end
    a.insured_pharmacies.each do |i|
      i.purchase_insured_pharmacies.where(is_facturated: nil).each do |p|
        p.is_facturated = true
        pay = b.pay_document
        a = pay.authorization
        clinic_ruc = a.clinic.ruc
        type_purchase = 'C'
        clinic_code = a.clinic.code
        payment_type_document = '01'
        payment_document = pay.code
        type_code = p.product_pharm_type.code
        sunasa_code = 'XXXXXXXXXXX'
        ean_code = 'XXXXXXXXXXXXX'
        if p.product_pharm_type_id != 1
          digemid_code = ' '*6
        else
          digemid_code = p.digemid_product.code
        end
        observation = nil
        date = p.insured_pharmacy.created_at.strftime("%Y-%m-%d")
        diagnostic_code = a.first_diagnostic
        exented_code = p.product_pharm_exented.code
        if b.detail_pharmacies.count == 0
          correlative = 1
        else
          correlative = b.detail_pharmacies.count + 1
        end
        correlative_benefit = 1      
        unitary = (p.initial_amount.to_f/p.quantity.to_f).to_f
        quantity = p.quantity
        copayment = p.copayment
        amount = (unitary * quantity).to_f
        pharm_guide = (p.insured_pharmacy.id + 5000).to_s
        index = p.id
        d = DetailPharmacy.create(observation: observation, benefit: b, correlative: correlative, clinic_ruc: clinic_ruc, clinic_code: clinic_code,  document_type_code: payment_type_document, document_number: payment_document, correlative_benefit: correlative_benefit, type_code: type_code, sunasa_code: sunasa_code, ean_code: ean_code, digemid_code: digemid_code, date: date, quantity: quantity, unitary: unitary, copayment: copayment, amount: amount, amount_not_covered: 0, diagnostic_code: diagnostic_code, exented_code: exented_code, pharm_guide: pharm_guide, index: index)
        p.save
      end
    end
    redirect_to ready_asign_facturation_path(pay_document_id: pay.id)
  end

  def add_detail_service
    b = Benefit.find(params[:benefit_id])
    p = PurchaseInsuredService.find(params[:detail_service_id])
    p.is_facturated = true
    i_service = p.insured_service
    pay = b.pay_document
    a = pay.authorization
    type_purchase = 'S'
    insurance = a.patient.insured.insurance
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
    observation = params[:observation]
    if b.detail_services.count == 0
      correlative = 1
    else
      order_benefit(b)
      correlative = b.detail_services.count + 1
    end
    correlative_benefit = 1
    sector_id = get_sector(p.service.contable_code)
    sector_code = Sector.find(sector_id).code
    unitary = p.initial_amount / p.unitary
    quantity = p.quantity
    copayment = p.copayment
    amount = (unitary * quantity).round(2)
    index = p.id
    d = DetailService.create(observation: observation, purchase_code: 'S', benefit: b, clasification_service_type_id: 3, correlative: correlative, clinic_ruc: clinic_ruc, clinic_code: clinic_code,  payment_type_document: payment_type_document, payment_document: payment_document, clasification_service_type_code: '03', service_code: service_code, service_description: service_description, date: date, professional_type: professional_type, tuition_code: tuition_code, quantity: quantity, unitary: unitary, copayment: copayment, amount: amount, amount_not_covered: 0, diagnostic_code: diagnostic_code, exented_code: exented_code, sector_id: sector_id, sector_code: sector_code, correlative_benefit: correlative_benefit, index: index)
    p.save
    b.upgrade_data_sales
    @doctors = to_hash_doctor(Doctor.all)
    @pay_document = PayDocument.find(d.benefit.pay_document.id)
    @document_types = to_hash(DocumentType.all)
    @product_pharm_types = to_hash(ProductPharmType.all)
    respond_to do |format|
      format.js
      format.html {redirect_to ready_asign_facturation_path(pay_document_id: pay.id)}
    end
  end

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
    if d.purchase_code == 'S'
      p = PurchaseInsuredService.find(d.index)
    else
      p = PurchaseCoverageService.find(d.index)
    end    
    @doctors = to_hash_doctor(Doctor.all)
    @pay_document = PayDocument.find(d.benefit.pay_document.id)
    @document_types = to_hash(DocumentType.all)
    @product_pharm_types = to_hash(ProductPharmType.all)    
    p.is_facturated = nil
    p.save
    d.destroy
    b.upgrade_data_sales
    respond_to do |format|
      format.js {  }
    end
  end

  def new_dental
    @pay_document = PayDocument.find(params[:pay_document_id])
    @status_dental = {'0' => 'No curado', '1' => 'Curado'}.invert
    @detail_dentals = @pay_document.benefit.detail_dentals
  end

  def add_dental
    d = DetailDental.create(benefit_id: params[:benefit_id], dental_code: params[:dental_code], mesial: params[:mesial], lingual: params[:lingual], distal: params[:distal], vestibular: params[:vestibular], oclusal: params[:oclusal], all_piece: params[:all_piece], palatina: params[:palatina], cervical: params[:cervical], incisal: params[:incisal])
    @pay_document = d.benefit.pay_document
    @detail_dentals = @pay_document.benefit.detail_dentals
    respond_to do |format|
      format.js
    end
  end

  def delete_dental
    d = DetailDental.find(params[:detail_dental_id])
    d.destroy
    order_dental(d.benefit)
    @pay_document = d.benefit.pay_document
    @detail_dentals = @pay_document.benefit.detail_dentals
    respond_to do |format|
      format.js
    end
  end

  def order_dental(benefit)
    if benefit.detail_dentals.exists?
      count = 1
      benefit.detail_dentals.each do |d|
        d.correlative_dental = count
        d.save
        count += 1
      end
    end
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
    b = pay.benefit
    @doctors = to_hash_doctor(Doctor.all)
    @pay_document = PayDocument.find(d.benefit.pay_document.id)
    @document_types = to_hash(DocumentType.all)
    @product_pharm_types = to_hash(ProductPharmType.all)   
    d.destroy
    b.upgrade_data_sales
    respond_to do |format|
      format.js
    end
  end

  def delete_detail_pharmacy
    d = DetailPharmacy.find(params[:detail_pharmacy_id])
    pay = Benefit.find(d.benefit_id).pay_document
    p = PurchaseInsuredPharmacy.find(d.index)
    p.is_facturated = nil
    p.save
    d.destroy
    b = pay.benefit
    @pay_document = pay
    @product_pharm_types = to_hash(ProductPharmType.all)
    b.upgrade_data_sales
    respond_to do |format|
      format.html {redirect_to ready_asign_facturation_path(pay_document_id: pay.id)}
      format.js
    end
  end

  def add_detail_pharmacy
    b = Benefit.find(params[:benefit_id])
    p = PurchaseInsuredPharmacy.find(params[:detail_pharmacy_id])
    p.is_facturated = true
    pay = b.pay_document
    a = pay.authorization
    clinic_ruc = a.clinic.ruc
    type_purchase = 'C'
    type_code = ProductPharmType.find(params[:product_pharm_type_id]).code
    clinic_code = a.clinic.code
    payment_type_document = '01'
    payment_document = pay.code
    type_code = ProductPharmType.find(params[:product_pharm_type_id]).code
    sunasa_code = 'XXXXXXXXXXX'
    ean_code = 'XXXXXXXXXXXXX'
    if params[:product_pharm_type_id] != '1'
      digemid_code = ' '*6
    else
      digemid_code = p.digemid_product.code
    end
    observation = params[:observation]
    date = p.insured_pharmacy.created_at.strftime("%Y-%m-%d")
    diagnostic_code = a.first_diagnostic
    exented_code = p.product_pharm_exented.code
    if b.detail_pharmacies.count == 0
      correlative = 1
    else
      order_benefit(b)
      correlative = b.detail_pharmacies.count + 1
    end
    correlative_benefit = 1      
    unitary = (p.initial_amount.to_f/p.quantity.to_f).to_f
    quantity = p.quantity
    copayment = p.copayment
    amount = (unitary * quantity).to_f
    pharm_guide = (p.insured_pharmacy.id + 5000).to_s
    index = p.id
    d = DetailPharmacy.create(observation: observation, benefit: b, correlative: correlative, clinic_ruc: clinic_ruc, clinic_code: clinic_code,  document_type_code: payment_type_document, document_number: payment_document, correlative_benefit: correlative_benefit, type_code: type_code, sunasa_code: sunasa_code, ean_code: ean_code, digemid_code: digemid_code, date: date, quantity: quantity, unitary: unitary, copayment: copayment, amount: amount, amount_not_covered: 0, diagnostic_code: diagnostic_code, exented_code: exented_code, pharm_guide: pharm_guide, index: index)
    p.save
    b.upgrade_data_sales
    @pay_document = d.benefit.pay_document
    @product_pharm_types = to_hash(ProductPharmType.all)
    respond_to do |format|
      format.html {redirect_to ready_asign_facturation_path(pay_document_id: pay.id)}
      format.js
    end
  end

  def add_detail_coverage

    b = Benefit.find(params[:benefit_id])
    p = PurchaseCoverageService.find(params[:detail_service_id])

    p.is_facturated = true
    i_service = p.insured_service
    pay = b.pay_document
    a = pay.authorization
    type_purchase = 'C'
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
    amount = (unitary * quantity)
    index = p.id
    observation = params[:observation]
    d = DetailService.create(observation: observation, :purchase_code => 'C', benefit: b, clasification_service_type_id: 3, correlative: correlative, clinic_ruc: clinic_ruc, clinic_code: clinic_code,  payment_type_document: payment_type_document, payment_document: payment_document, clasification_service_type_code: '03', service_code: service_code, service_description: service_description, date: date, professional_type: professional_type, tuition_code: tuition_code, quantity: quantity, unitary: unitary, copayment: copayment, amount: amount, amount_not_covered: 0, diagnostic_code: diagnostic_code, exented_code: exented_code, sector_id: sector_id, sector_code: sector_code, correlative_benefit: correlative_benefit, index: index)

    pay = d.benefit.pay_document
    pay.has_consultation = true
    pay.save
    p.save
    b.upgrade_data_sales
    @doctors = to_hash_doctor(Doctor.all)
    @pay_document = PayDocument.find(d.benefit.pay_document.id)
    @document_types = to_hash(DocumentType.all)
    @product_pharm_types = to_hash(ProductPharmType.all) 
    respond_to do |format|
      format.js 
    end
  end


  def form_accounting
    if params[:message] == '1'
      @message = "Data exportada correctamente"
    end
  end

  def export_accounting
    Axlsx::Package.new do |p| 
      row_1=['Sistema','Fecha','TD','Serie','Numero','Ruc','Razon','Codigo','Descrip','Importe','Clase','TipoP']
      p.workbook.add_worksheet(:name => "Registro de ventas 2") do |sheet|
        sheet.add_row row_1, style: sheet.styles.add_style(:bg_color => "9AEDF0", :fg_color=>"#FF000000", :sz=>11,  :border=> {:style => :thin, :color => "FFFF0000"})
        PayDocument.where('code <> "0001-0000000" and is_closed is not NULL and emission_date > ? and emission_date < ?', params[:date_initial], params[:date_final]).order(id: :desc).each do |pay|
          unless pay.benefit.nil?
            pay.benefit.detail_services.each do |d|            
              sheet.add_row [pay.id,pay.emission_date.strftime("%d/%m/%Y"),'01','0001',pay.code[5,7],pay.insurance_ruc,pay.social,d.service_code,d.service_description,d.amount,'N','S'], :types => [:string, :string,:integer, :string ,:string ,:string, :string, :string, :string, :float]
            end
            pay.liquidation_array.each do |l|
              i = InsuredPharmacy.where(liquidation: l).last
              if i.pharm_type_sale_id == 1
                sheet.add_row [pay.id,pay.emission_date.strftime("%d/%m/%Y"),'01'.to_s,'0001'.to_s,pay.code[5,7],pay.insurance_ruc,pay.social,'1000003','FARMACIA',i.initial_amount,'N','M'], :types => [:string, :string,:integer, :string ,:string ,:string, :string, :string, :string, :float]
              else
                sheet.add_row [pay.id,pay.emission_date.strftime("%d/%m/%Y"),'01'.to_s,'0001'.to_s,pay.code[5,7],pay.insurance_ruc,pay.social,'1000004','INSUMOS',i.initial_amount,'N','M'], :types => [:string, :string,:integer, :string ,:string ,:string, :string, :string, :string, :float]
              end
            end
            sheet.add_row [pay.id,pay.emission_date.strftime("%d/%m/%Y"),'01','0001',pay.code[5,7],pay.insurance_ruc,pay.social,'1000001','COPAGO FIJO','-'+pay.total_cop_fijo.to_s,'N','S'] , :types => [:string, :string,:integer, :string ,:string ,:string, :string, :string, :string, :float]
            sheet.add_row [pay.id,pay.emission_date.strftime("%d/%m/%Y"),'01','0001',pay.code[5,7],pay.insurance_ruc,pay.social,'1000002','COPAGO VARIABLE','-'+pay.total_cop_var.to_s,'N','S'], :types => [:string, :string,:integer, :string ,:string ,:string, :string, :string, :string, :float]
            sheet.add_row [pay.id,pay.emission_date.strftime("%d/%m/%Y"),'01','0001',pay.code[5,7],pay.insurance_ruc,pay.social,'-','IMPUESTO',pay.total_igv.to_s,'I',''], :types => [:string, :string,:integer, :string ,:string ,:string, :string, :string, :string, :float]
            sheet.add_row [pay.id,pay.emission_date.strftime("%d/%m/%Y"),'01','0001',pay.code[5,7],pay.insurance_ruc,pay.social,'-','TOTAL',pay.total_amount.to_s,'T',''], :types => [:string, :string,:integer, :string ,:string ,:string, :string, :string, :string, :float]
          end
        end        
      end     
      p.serialize('/home/fabian/exportacion.xlsx')
    end
    redirect_to form_accounting_path(message: '1')
  end

  def form_export_special

  end

  def new_export_facturation
    if File.exist?('/var/tedef/exportacion_' + params[:date_initial] + params[:date_final] + '.xlsx')
      File.chmod(0777, '/var/tedef/exportacion_' + params[:date_initial] + params[:date_final] + '.xlsx')
      File.delete('/var/tedef/exportacion_' + params[:date_initial] + params[:date_final] + '.xlsx')
    end
    row_1 = ['Aseguradora', 'Compañía', 'RUC Entidad Vinculada', 'Fecha Envio Conciliacion', 'Tipo Documento', 'Nro de Serie', 'Numero Documento', 'Fecha de Emision', 'Total Factura', 'Producto', 'Fecha de Envio', 'Moneda', 'Fecha atención']

    Axlsx::Package.new do |pa|
      pa.workbook.add_worksheet(:name => "Exportación") do |sheet|
        sheet.add_row row_1
        PayDocument.where('code <> "0001-0000000" and is_closed is not NULL and emission_date > ? and emission_date < ?', params[:date_initial], params[:date_final]).order(:code).each do |p|
          sheet.add_row [p.social.to_s, '01', '20494306043', '', '01', '0001', p.code[5,7] ,p.emission_date.strftime("%Y%m%d"), "%.2f" % p.total_amount.to_s, '1402', '', '01', p.authorization.date.strftime("%Y%m%d")] , :types => [:string, :string, :string, :string ,:string ,:string, :string, :string, :float, :string]
        end        
      end
      pa.serialize('/var/tedef/exportacion_' + params[:date_initial] + params[:date_final] + '.xlsx')
    end
    redirect_to form_export_special_path
  end 
end