module FacturationsHelper
	def html_status(status)
		case status
		when 'R'
			'Refacturada'
		when 'N'
			'Correcta'
		when 'D'
			'Anulada'
		else
			'Error'
		end
	end
end
