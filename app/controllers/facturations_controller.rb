class FacturationsController < ApplicationController
  def index
  	@authorizations = Authorization.order(date: :desc).paginate(:page => params[:page])
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
  end

  def benefit
    @document_types = to_hash(DocumentType.all)
    @benefit = Benefit.find(params[:benefit_id])
  end

  def asign
    @pay_document = PayDocument.find(params[:pay_document_id])
    @document_types = to_hash(DocumentType.all)
  end

  def confirm
  	@authorization = Authorization.find(params[:authorization_id])
    p = PayDocument.create(authorization: @authorization)
    b = Benefit.create(pay_document: p)
    redirect_to ready_principal_facturation_path(pay_document_id: p.id)
  end

  def show

  end

  def update_principal
    p = PayDocument.find(params[:id])
    p.sub_mechanism_pay_type_id = params[:sub_mechanism_pay_type_id]
    p.pay_document_type_id = params[:pay_document_type_id]
    p.indicator_global_id = params[:indicator_global_id]
    p.save
    redirect_to ready_principal_facturation_path(pay_document_id: p.id)
  end

  def update_benefit
    b = Benefit.find(params[:id])
    b.document_type_id = params[:document_type_id]
    b.document_type_code = params[:document_type_code]
    b.save
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
end
