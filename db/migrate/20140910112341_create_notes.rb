class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.integer :note_type_id
      t.float :amount
      t.string :number
      t.date :date
      t.integer :reason_id
      t.integer :pay_document_id

      t.timestamps
    end
  end
end
