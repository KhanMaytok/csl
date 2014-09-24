class CreatePurchaseCoverageServices < ActiveRecord::Migration
  def change
    create_table :purchase_coverage_services do |t|
      t.references :insured_service, index: true
      t.references :service, index: true
      t.float :unitary
      t.float :copayment
      t.float :igv
      t.float :final_amount
      t.boolean :is_facturated
      t.integer :correlative

      t.timestamps
    end
  end
end
