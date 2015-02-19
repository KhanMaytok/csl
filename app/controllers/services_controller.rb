class ServicesController < ApplicationController
	before_action :set_service, only: [:update_contable_code, :delete]

	def index
		@services = Service.where('name like "%'+ params[:search].to_s + '%" or code like "%' + params[:search].to_s + '%"').paginate(page: params[:page])
		@contable_codes = {'HONORARIOS, PROCEDIMIENTOS MÉDICOS Y Q' => '1', 'PROCEDIMIENTOS ODONTOLOGICOS' => '2', 'HOTELERÍA SERVICIO CLINICO Y TOPICO' => '3', 'EXAMENES AUXILIARES DE LABORATORIO' => '4', 'DIAGNOSTICOS POR IMAGENES Y OTROS DE AYUDA' => '5', 'OTROS' => '9'}
		@clinic_areas = ClinicArea.all
		respond_to do |format|
			format.html
			format.js
		end
	end

	def update_contable_code
		@service.update(contable_code: params[:contable_code])
		@contable_codes = {'HONORARIOS, PROCEDIMIENTOS MÉDICOS Y Q' => '1', 'PROCEDIMIENTOS ODONTOLOGICOS' => '2', 'HOTELERÍA SERVICIO CLINICO Y TOPICO' => '3', 'EXAMENES AUXILIARES DE LABORATORIO' => '4', 'DIAGNOSTICOS POR IMAGENES Y OTROS DE AYUDA' => '5', 'OTROS' => '9'}
		@services = Service.where('name like "%'+ params[:search].to_s + '%"').paginate(page: params[:page])
		respond_to do |format|
			format.html { redirect_to services_path(page: 1) }
			format.js
		end
	end

	def create
		@service = Service.new(service_params)
		@service.save
		@services = Service.where('name like "%'+ params[:search].to_s + '%"').paginate(page: params[:page])
		@contable_codes = {'HONORARIOS, PROCEDIMIENTOS MÉDICOS Y Q' => '1', 'PROCEDIMIENTOS ODONTOLOGICOS' => '2', 'HOTELERÍA SERVICIO CLINICO Y TOPICO' => '3', 'EXAMENES AUXILIARES DE LABORATORIO' => '4', 'DIAGNOSTICOS POR IMAGENES Y OTROS DE AYUDA' => '5', 'OTROS' => '9'}
		respond_to do |format|
			format.html { redirect_to services_path(page: 1) }
			format.js
		end
	end

	def delete
		@service.destroy
		@services = Service.where('name like "%'+ params[:search].to_s + '%"').paginate(page: params[:page])
		@contable_codes = {'HONORARIOS, PROCEDIMIENTOS MÉDICOS Y Q' => '1', 'PROCEDIMIENTOS ODONTOLOGICOS' => '2', 'HOTELERÍA SERVICIO CLINICO Y TOPICO' => '3', 'EXAMENES AUXILIARES DE LABORATORIO' => '4', 'DIAGNOSTICOS POR IMAGENES Y OTROS DE AYUDA' => '5', 'OTROS' => '9'}
		respond_to do |format|
			format.html { redirect_to services_path(page: 1) }
			format.js
		end
	end

	private

	def set_service
		@service = Service.find(params[:service_id])
	end

	def service_params
		params.require(:service).permit(:name, :code, :contable_code, :clinic_area_id)
	end
end