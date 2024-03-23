class CreateCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :collections, id: :uuid do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.references :lot, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
