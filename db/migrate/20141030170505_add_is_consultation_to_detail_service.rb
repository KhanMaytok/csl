class AddIsConsultationToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :type, :string
  end
end
