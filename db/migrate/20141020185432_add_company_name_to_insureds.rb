class AddCompanyNameToInsureds < ActiveRecord::Migration
  def change
    add_column :insureds, :company_name, :string
  end
end
