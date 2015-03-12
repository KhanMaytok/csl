class SecurityController < ApplicationController
  def index
    if is_loged?
      redirect_to root_path
    end
    if params[:message] == '1'
      @error = 'Usuario o contraseña incorrectos'
    end

  end
  
  def login
  	if validate(params[:username], params[:password])
  		redirect_to root_path(message: '1')
  	else
  		redirect_to security_path(message: '1')
    end
  end

  def logout
  	if request.get?
  		session.destroy
  	end
  	redirect_to security_path
  end

  private

  def validate(username, password)
  	if !Employee.where(username: username, password: password).last.nil?
  		employee = Employee.find_by_username(username)
  		session[:id] = employee.id
  		session[:status] = true
  		return true
  	else
  		return false
  	end
  end
end
