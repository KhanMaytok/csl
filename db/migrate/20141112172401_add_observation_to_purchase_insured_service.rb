class AddObservationToPurchaseInsuredService < ActiveRecord::Migration
  def change
    add_column :purchase_insured_services, :observation, :text
  end
end
