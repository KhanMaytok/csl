class ChatController < ApplicationController
	respond_to :html, :js
  def index
  	@messages = Message.order(created_at: :desc)
  end

  def add
  	unless (params[:body]).strip == '' or (params[:body]).strip.nil?
  		if params[:flag] == '1'
	  		Message.create(employee_id: params[:employee_id], body: (params[:body]).strip)
	  	end 
  	end  		
  	@messages = Message.order(created_at: :desc)
  	respond_to do |format|
  		format.js
  	end
  end
end
