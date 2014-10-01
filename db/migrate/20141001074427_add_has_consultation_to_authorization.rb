class AddHasConsultationToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :has_consultation, :boolean
  end
end
