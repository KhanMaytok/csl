class AddFirstDiagnosticToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :first_diagnostic, :string
  end
end
