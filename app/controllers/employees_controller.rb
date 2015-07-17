class EmployeesController < ApplicationController
  def index
  	@employees = Employee.where(area_id: 1).joins(:area).order("areas.id desc")
  end
end
