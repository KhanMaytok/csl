class AddExpenseOtherToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :expense_other, :float
  end
end
