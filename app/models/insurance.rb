class Insurance < ActiveRecord::Base
	has_many :insureds
	has_many :factors, dependent: :destroy

	validates :name, presence: {message: 'Razón Social no puede estar en blanco'}
	validates :name, uniqueness: {message: 'Razón Social está repetido'}, on: [:create]
	validates :name, length: { minimum: 5,message: 'Razón Social es muy pequeño'}
	validates :ruc, presence: {message: 'Ruc no puede estar en blanco'}
	validates :ruc, length: { is: 11, message: 'Ruc debe tener 11 carácteres'}
	# validates :ruc, uniqueness: {message: 'Ruc está repetido'}, on: [:create]
	validates :ruc, numericality: { only_integer: true, message: 'Ruc debe tener solamente números'}
	validates :ruc, numericality: { only_integer: true, message: 'Ruc debe tener solamente números'}
	validates :address, presence: {message: 'Dirección no puede estar en blanco'}

	after_create :set_factors

	before_create :set_columns

	def set_factors
		8.times do |t|
			self.factors.create(clinic_area_id: t + 1, factor: 1)
		end
	end

	def set_columns
		self.show = true
		self.consultation ||= 0
	end

	def update_factors(factors)
		factors.each_with_index do |factor, index|
			self.factors.where(clinic_area_id: index + 1).last.update(factor: factor)
		end
	end
	# 96048-86045

end
