class AddInfoToPurchaseParticularService < ActiveRecord::Migration
  def change
    add_reference :purchase_particular_services, :particular_service, index: true
  end
end
