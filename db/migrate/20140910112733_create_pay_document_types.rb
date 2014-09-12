class CreatePayDocumentTypes < ActiveRecord::Migration
  def change
    create_table :pay_document_types do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
