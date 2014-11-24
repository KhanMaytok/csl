class AddHasTicketToInsuredPharmacy < ActiveRecord::Migration
  def change
    add_column :insured_pharmacies, :has_ticket, :boolean
  end
end
