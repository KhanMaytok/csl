class AddProfessionaIdentityTypeCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :professional_identity_type_code, :string
  end
end
