class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def to_name_i(insured)
  	insured.name+ " " + insured.paternal + " " + insured.maternal
  end

  def to_name_h(insured)
  	insured.hold_name+ " " + insured.hold_paternal + " " + insured.hold_maternal
  end

  def to_hash(query)
    hash = Hash.new
    query.each do |q|
      hash[q.name] = q.id
    end
    hash
  end

  def get_time
    return Time.now.to_i
  end

  def active(controller)    
      if controller == params[:controller]
        'class=active'
      end
  end

  def age(birthday)
    now = Time.now.utc.to_date
    now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
  end

  def current_employee
    @employee = Employee.find(session[:id])
  end

  def is_loged?
    !!session[:status]
  end

  def block_unloged
    if !session[:status]
      redirect_to security_path
    end
  end

  helper_method :to_name_i, :to_name_h, :age, :active, :current_employee, :is_loged?
end
