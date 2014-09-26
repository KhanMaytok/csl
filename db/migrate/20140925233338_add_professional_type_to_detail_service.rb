class AddProfessionalTypeToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :professional_type, :string
  end
end
