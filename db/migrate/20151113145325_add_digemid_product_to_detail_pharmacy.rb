class AddDigemidProductToDetailPharmacy < ActiveRecord::Migration
	def change
		add_reference :detail_pharmacies, :digemid_products, index: true
		add_column :detail_pharmacies, :manual, :boolean
	end
end
