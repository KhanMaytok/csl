class AddInterCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :intern_code, :string
  end
end
