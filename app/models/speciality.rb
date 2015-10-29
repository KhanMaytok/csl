class Speciality < ActiveRecord::Base
	has_many :doctors

	# default_scope :include => { doctors: :authorizations }, :order => "sum(count(authorizations.id))"

	def authorizations
		Authorization.joins(:doctor).where('doctors.speciality_id = ?', self.id)
	end

	def number_authorizations
		Authorization.joins(:doctor).where('doctors.speciality_id = ?', self.id).count
	end
end
