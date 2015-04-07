class AddTuitionCodeToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :tuition_code, :string
  end
end
