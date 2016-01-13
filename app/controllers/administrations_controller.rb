class AdministrationsController < ApplicationController
  before_action :block_unloged
  def index
    @specialities = Speciality.all
  end

  def stadistics
    @ps = PurchaseInsuredPharmacy.eager_load(:insured_pharmacy, :digemid_product, detail_pharmacy: { benefit: :pay_document }).joins(:insured_pharmacy).where("insured_pharmacies.date_create > '2015-01-01' and insured_pharmacies.date_create < '2015-03-31' and insured_pharmacies.pharm_type_sale_id = 2")
  end

  def test
    @authorizations = Authorization.includes(patient: [{ insured: :insurance }], coverage: [{ sub_coverage_type: :coverage_type }]).joins(:coverage, patient: :insured).where('month(date) in (4,5,6,7,8,9) and year(date) = 2015 and insureds.insurance_id in (1,6) and coverages.sub_coverage_type_id in (95,772,773,774,775,776,777,778,779,780,790,851,861,862,863,864,865)').order(date: :asc)
  end

  def show_export
    if params[:message] == '1'
      @message = 'Exportado correctamente'
    end
  end
  
  def export_pdf
    kit = PDFKit.new('http://192.168.1.254/ingresar')
    kit.to_file('/home/fabian/demo12.pdf')
    redirect_to root_path
  end

  def trama
    year = '2015'
    month = '02'
    @patients_b = Patient.joins(authorizations: { coverage: :sub_coverage_type }).where("year(date) = #{year} and month(date) = #{month} and coverage_type_id = 5").distinct
    @patients_b.assign_age_group
    @array_patients_b = @patients_b.array_separate_group
    Patient.print_b1_b2(@array_patients_b, year, month)

    @patients_c = Patient.joins(authorizations: { coverage: :sub_coverage_type }).where("year(date) = #{year} and month(date) = #{month} and coverage_type_id = 7").distinct
    @patients_c.assign_age_group
    @array_patients_c = @patients_c.array_separate_group
    Patient.print_c1_c2(@array_patients_c, year, month)

    @patients_d = Patient.joins(authorizations: { coverage: :sub_coverage_type }).where("year(date) = #{year} and month(date) = #{month} and coverage_type_id = 6").distinct
    @patients_d.assign_age_group
    @array_patients_d = @patients_d.array_separate_group
    # Patient.print_d1_d2(@array_patients_d, year, month)
  end

  def export_services
    row_1 = ['', '', 'SERVICIOS CLINICA SEÑOR DE LUREN']
    header = ['', 'Código de servicio', 'Nombre de servicio', 'Área clinica', 'Código contable', 'Nombre contable']
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "Servicios") do |sheet|
        sheet.add_row row_1, style: sheet.styles.add_style(:bg_color => "9AEDF0", :fg_color=>"#FF000000", :sz=>14,  :border=> {:style => :thin, :color => "FFFF0000"})
        sheet.add_row [' ']
        sheet.add_row header
        Service.all.each do |s|
          unless s.clinic_area.nil?
            sheet.add_row ['', s.code, s.name, s.clinic_area.name.to_s, s.contable_code, s.contable_name]        				
          else
            sheet.add_row ['', s.code, s.name, 'No ingresado', s.contable_code, s.contable_name]        				
          end	    	
        end
      end
      p.serialize('/home/and/'+Time.now.to_s+'.xlsx')
    end
    redirect_to show_export_path(message: '1')
  end
end