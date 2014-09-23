class CreatePayDocuments < ActiveRecord::Migration
  def change
    create_table :pay_documents do |t|
      t.references :pay_document_type_id, index: true
      t.references :authorization_id, index: true
      t.references :sub_mechanism_pay_type_id, index: true
      t.references :indicator_global_id, index: true
      t.references :pay_document_group_id, index: true
      t.references :product_code_id, index: true
      t.string :code
      t.date :emission_date
      t.integer :benefits_quantity
      t.float :pre_agreed
      t.date :init_pre_agreed
      t.float :amount_medicine_exonerated
      t.float :cop_fijo
      t.float :cop_var
      t.float :net_amount

      t.timestamps
    end
  end
end
