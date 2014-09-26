class AddAfiliationTypeCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :afiliation_type_code, :string
  end
end
