class RemoveInfoFromPurchaseParticularService < ActiveRecord::Migration
  def change
    remove_column :purchase_particular_services, :insured_service_id, :integer
  end
end
