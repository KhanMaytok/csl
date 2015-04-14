class RemoveInterFromBenefit < ActiveRecord::Migration
  def change
    remove_column :benefits, :cod_benefit_intern, :string
  end
end
