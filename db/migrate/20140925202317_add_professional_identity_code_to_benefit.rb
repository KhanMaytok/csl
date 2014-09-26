class AddProfessionalIdentityCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :professional_identity_code, :string
  end
end
