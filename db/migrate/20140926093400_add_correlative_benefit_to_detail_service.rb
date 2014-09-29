class AddCorrelativeBenefitToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :correlative_benefit, :integer
  end
end
