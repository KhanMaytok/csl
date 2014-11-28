class AddTuitionCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :tuition_code, :string
  end
end
