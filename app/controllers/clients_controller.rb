class ClientsController < ApplicationController
	before_action :set_client, only: [:update, :edit, :update_factors]

	def index
		@clients = Insurance.order(id: :desc).where(show: true)
		@client = Insurance.new
	end

	def create
		@client = Insurance.create(client_params)
	end

	def edit
		@factors = @client.factors
	end

	def update
		@client.update(client_params)
	end

	def update_factors
		@client.update_factors(params.select{ |key| key.to_s.include? 'factor' }.values)
	end

	private

	def client_params
		params.require(:insurance).permit(:name, :code, :ruc, :consultation, :address)
	end

	def set_client
		@client = Insurance.find(params[:client_id])
	end
end
