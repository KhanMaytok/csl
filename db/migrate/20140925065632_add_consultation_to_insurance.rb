class AddConsultationToInsurance < ActiveRecord::Migration
  def change
    add_column :insurances, :consultation, :float
  end
end
