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

  def age(birthday)
	((Time.now - Time.new(birthday))/(60*60*24)/365.2422).to_i.to_s
  end

  helper_method :to_name_i, :to_name_h, :age
end
