class AddSectorCodeToDetailService < ActiveRecord::Migration
  def change
    add_column :detail_services, :sector_code, :string
  end
end
