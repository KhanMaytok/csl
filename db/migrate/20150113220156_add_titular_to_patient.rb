class AddTitularToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :representative, :string
    add_column :patients, :document_identity_code_representative, :string
  end
end
