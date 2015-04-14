class AddSecondDiagnosticToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :second_diagnostic, :string
  end
end
