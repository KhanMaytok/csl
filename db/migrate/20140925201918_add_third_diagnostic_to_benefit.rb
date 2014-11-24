class AddThirdDiagnosticToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :third_diagnostic, :string
  end
end
