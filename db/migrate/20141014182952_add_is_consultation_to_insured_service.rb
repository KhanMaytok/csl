class AddIsConsultationToInsuredService < ActiveRecord::Migration
  def change
    add_column :insured_services, :is_consultation, :boolean
  end
end
