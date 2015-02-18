class ServicesController < ApplicationController
	before_action :set_service, only: [:update_contable_code]
	def index
		@services = Service.where('name like "%'+ params[:search].to_s + '%" or code like "%' + params[:search].to_s + '%"').paginate(page: params[:page])
		respond_to do |format|
			format.html
			format.js
		end
	end

	def update_contable_code
		@service.update(contable_code: params[:contable_code])
		@services = Service.where('name like "%'+ params[:search].to_s + '%"').paginate(page: params[:page])
		respond_to do |format|
			format.html { redirect_to services_path(page: 1) }
			format.js
		end
	end

	private

	def set_service
		@service = Service.find(params[:service_id])
	end
end