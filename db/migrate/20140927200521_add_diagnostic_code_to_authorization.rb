class AddDiagnosticCodeToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :first_diagnostic, :string
    add_column :authorizations, :second_diagnostic, :string
    add_column :authorizations, :third_diagnostic, :string
  end
end
