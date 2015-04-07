class InsuredsController < ApplicationController
  before_action :block_unloged
  def index
  	if params[:paternal].nil?
  		@insureds = Insured.paginate(:page => params[:page])
  	else
  		@insureds = Insured.joins(:patient).where("paternal like '%"+params[:paternal]+"%'").paginate(:page => params[:page])
  	end  	
  end

  def show
  	@insured = Insured.find(params[:id])
  end
end
