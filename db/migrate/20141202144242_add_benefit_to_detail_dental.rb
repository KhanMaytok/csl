class AddBenefitToDetailDental < ActiveRecord::Migration
  def change
    add_reference :detail_dentals, :benefit, index: true
  end
end
