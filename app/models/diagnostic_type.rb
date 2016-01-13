class DiagnosticType < ActiveRecord::Base
	scope :random, -> { offset(rand(count)).first }
end
