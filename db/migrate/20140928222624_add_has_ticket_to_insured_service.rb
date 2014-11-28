class AddHasTicketToInsuredService < ActiveRecord::Migration
  def change
    add_column :insured_services, :has_ticket, :boolean
  end
end
