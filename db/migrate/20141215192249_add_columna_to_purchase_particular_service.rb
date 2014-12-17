class AddColumnaToPurchaseParticularService < ActiveRecord::Migration
  def change
    add_column :purchase_particular_services, :is_closed, :boolean
   	
  end
end
