class AdministrationsController < ApplicationController
  before_action :block_unloged
  def index
    @specialities = Speciality.all
  end

  def stadistics
    @authorizations = Authorization.where("year(date) = 2015")
    @ambulatories = @authorizations.diagnostics(5)
    @hospitalaries = @authorizations.diagnostics(6)
    @emergencies = @authorizations.diagnostics(7)
    @specialities = Speciality.joins(doctors: :authorizations).includes(doctors: :authorizations).where("year(authorizations.date) = 2015")
    @cesareas = @authorizations.joins(coverage: :sub_coverage_type).where("sub_coverage_types.name like '%cesarea%'").count
    @good_boy = @authorizations.joins(coverage: :sub_coverage_type).where("sub_coverage_types.name like '%niño sano%'").count
    # @patients_pharm = @authorizations.joins(insured_pharmacies: { purchase_insured_pharmacies: :digemid_product }).where(" year(authorizations.date) = 2015 and (digemid_products.name like '%hidrocortisona%' or digemid_products.name like '%dexametasona%' or digemid_products.name like '%clorfenamina%' or digemid_products.name like '%medicort%') ").distinct
    @ira = @authorizations.joins(:diagnostic_type).where(" name like '%infeccion%' and name like '%respira%'");
    @embarazo = @authorizations.joins(:diagnostic_type).where(" name like '%hemorragia%' and name like '%embarazo%'");
    @ninos = @authorizations.joins(:diagnostic_type, :patient).where(" diagnostic_types.code like '%A09%'").order('patients.birthday desc');
    @bajo_peso = @authorizations.joins(:diagnostic_type, :patient).where(" diagnostic_types.code like '%a09%'").order('authorizations.date desc');
    @doctors = Doctor.all.order(:complet_name)
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
    patients = Patient.joins(:authorizations).where("date > '2015-10-03' and date < '2015-10-05'")
    array = Hash.new
    patients.each do |patient|
      if array[group_ages(patient.current_age)].nil?
        array[group_ages(patient.current_age)] = 0
      end
      array[group_ages(patient.current_age)] += 1
    end
    render text: array
  end

  def sex(sex)
    case sex
    when 'condition'
      
    end
  end

  def group_ages(age)
    case age
    when 0
      1
    when 1..4
      2
    when 5..9
      3
    when 10..14
      4
    when 15..19
      5
    when 20..24
      6
    when 25..29
      7
    when 30..34
      8
    when 35..39
      9
    when 40..44
      10
    when 45..49
      11
    when 50..54
      12
    when 55..59
      13
    when 60..64
      14
    when 65..150
      15
    end
    
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