class EmployeesController < ApplicationController
  def index
  	@employees = Employee.all.joins(:area).order("areas.id desc")
  end
end
