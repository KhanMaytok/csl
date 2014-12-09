class AdministrationsController < ApplicationController
  before_action :block_unloged
  def index
  end

  def stadistics
  	@report = Company.find(58).insureds.joins(:patient => :authorizations).group('patients.id')
  end

  def show_export
  	if params[:message] == '1'
  		@message = 'Exportado correctamente'
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