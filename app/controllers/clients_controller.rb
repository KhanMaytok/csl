class ClientsController < ApplicationController
	def index
		@clients = Insurance.all
	end
end
