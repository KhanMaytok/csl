class AdministrationsController < ApplicationController
  before_action :block_unloged
  def index
  end

  def stadistics
  	@report = Company.find(58).insureds.joins(:patient => :authorizations).group('patients.id')
  end
end