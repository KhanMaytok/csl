class WelcomeController < ApplicationController
	before_action :block_unloged
  def index 		
  	@insureds = Insured.paginate(:page => params[:page])
  	if params[:message] == '1'
 		@message = 'Autenticado en el sistema correctamente'
  	end
  end
end
