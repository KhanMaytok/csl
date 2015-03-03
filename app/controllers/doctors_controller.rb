class DoctorsController < ApplicationController
	before_action :set_doctor, only: [:update, :delete]
	def index
		@doctors = Doctor.all
		@specialities = Speciality.where('name <> ""')
	end

	def create
		@doctor = Doctor.new(doctor_params)
		@doctor.save
		@specialities = Speciality.where('name <> ""')
		@doctors = Doctor.all
		respond_to do |format|
			format.html { render text: params }
			format.js
		end
	end

	def update
		@doctor.update(doctor_params)
		@specialities = Speciality.where('name <> ""')
		@doctors = Doctor.all
		respond_to do |format|
			format.html { render text: params }
			format.js
		end
	end

	def delete
		@doctor.destroy		
		@specialities = Speciality.where('name <> ""')
		@doctors = Doctor.all
		respond_to do |format|
			format.html { render text: params }
			format.js
		end
	end

	private

	def set_doctor
		@doctor = Doctor.find(params[:doctor_id])
	end

	def doctor_params
		params.require(:doctor).permit(:complet_name, :document_identity_code, :tuition_code, :speciality_id)
	end
end
