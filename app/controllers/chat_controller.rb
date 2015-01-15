class ChatController < ApplicationController
	respond_to :html, :js
  def index
  	@messages = Message.order(created_at: :desc)
  end

  def add
  	unless (params[:body]).strip == '' or (params[:body]).strip.nil?
      employee = Employee.find(params[:employee_id])
  		if params[:flag] == '1'
	  		Message.create(employee_id: employee.id, body: (params[:body]).strip)
	  	end 
  	end 
  	@messages = Message.order(created_at: :desc)
    unless employee.id == 1
      Notifier.welcome(employee.complete_name, params[:body]).deliver
    end
  	respond_to do |format|
      format.html { redirect_to chat_path}
  		format.js
  	end
  end
end
