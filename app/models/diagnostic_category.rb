class DiagnosticCategory < ActiveRecord::Base
	has_many :diagnostics
end
