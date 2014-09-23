class CreatePayDocumentGroups < ActiveRecord::Migration
  def change
    create_table :pay_document_groups do |t|
      t.string :code
      t.string :name
      t.integer :quantity
      t.date :date
      t.time :time

      t.timestamps
    end
  end
end
