class RemoveInitialAmountFromDetailService < ActiveRecord::Migration
  def change
    remove_column :detail_services, :initial_amount, :string
  end
end
