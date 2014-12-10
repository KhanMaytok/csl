class AddGroupToDetailDental < ActiveRecord::Migration
  def change
    add_reference :detail_dentals, :detail_dental_group, index: true
  end
end
