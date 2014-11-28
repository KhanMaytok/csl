class AddPharmTypeSaleToInsuredPharmacy < ActiveRecord::Migration
  def change
    add_reference :insured_pharmacies, :pharm_type_sale, index: true
  end
end
