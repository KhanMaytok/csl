class CreateDetailDentals < ActiveRecord::Migration
  def change
    create_table :detail_dentals do |t|
      t.string :ipress_ruc
      t.string :ipress_code
      t.string :document_payment_type
      t.string :document_payment_code
      t.string :correlative
      t.string :correlative_dental
      t.string :dental_code
      t.string :mesial
      t.string :lingual
      t.string :distal
      t.string :vestibular
      t.string :oclusal
      t.string :all_piece
      t.string :palatina
      t.string :cervical
      t.string :incisal

      t.timestamps
    end
  end
end
