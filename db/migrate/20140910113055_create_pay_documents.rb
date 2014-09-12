class CreatePayDocuments < ActiveRecord::Migration
  def change
    create_table :pay_documents do |t|
      t.integer :authorization_id
      t.string :pay_document_type_id
      t.string :code
      t.string :emission_date
      t.integer :product_code_id
      t.integer :benefits_quantity
      t.integer :sub_mechanism_pay_type_id
      t.float :pre_agreed
      t.date :init_pre_agreed_date
      t.float :amount_medicine_exonerated
      t.float :total_cop_fijo
      t.float :total_cop_var
      t.float :net_amount
      t.float :igv
      t.float :total_amount
      t.integer :indicator_global_id

      t.timestamps
    end
  end
end
