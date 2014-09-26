class AddIsClosedToPurchaseCoverageService < ActiveRecord::Migration
  def change
    add_column :purchase_coverage_services, :is_closed, :boolean
  end
end
