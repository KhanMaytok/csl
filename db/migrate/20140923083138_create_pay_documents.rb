class CreatePayDocuments < ActiveRecord::Migration
  def change
    create_table :pay_documents do |t|
      t.references :pay_document_type, index: true
      t.references :pay_document_group, index: true
      t.references :sub_mechanism_pay_type, index: true
      t.references :indicator_global, index: true
      t.references :authorization, index: true
      t.string :code
      t.date :emission_date
      t.string :product_code
      t.float :pre_agreed
      t.date :date_pre_agreed
      t.float :amount_medicine_exonerated
      t.float :total_cop_fijo
      t.float :total_cop_var
      t.float :net_amount
      t.float :total_igv
      t.float :total_amount
      t.boolean :has_notes

      t.timestamps
    end
  end
end
