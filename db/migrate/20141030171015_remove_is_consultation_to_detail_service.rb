class RemoveIsConsultationToDetailService < ActiveRecord::Migration
  def change
    remove_column :detail_services, :type, :string
  end
end
