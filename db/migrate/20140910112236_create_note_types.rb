class CreateNoteTypes < ActiveRecord::Migration
  def change
    create_table :note_types do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
