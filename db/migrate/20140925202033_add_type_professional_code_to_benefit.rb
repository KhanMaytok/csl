class AddTypeProfessionalCodeToBenefit < ActiveRecord::Migration
  def change
    add_column :benefits, :type_professional_code, :string
  end
end
