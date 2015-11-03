class ClientsController < ApplicationController
	before_action :set_client, only: [:update]

	def index
		@clients = Insurance.order(id: :desc)
		@client = Insurance.new
	end

	def create
		@client = Insurance.create(client_params)
	end

	def update
		@client.udpate(client_params)
	end

	private

	def client_params
		params.require(:insurance).permit(:name, :code, :ruc, :consultation, :address)
	end

	def set_client
		@client = Insurance.find(params[:client_id])
	end
end
