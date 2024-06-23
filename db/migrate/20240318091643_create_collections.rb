class CreateCollections < ActiveRecord::Migration[7.0]
  def change
    create_table :collections, id: :uuid do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.references :collectable, polymorphic: true, type: :uuid, null: true

      t.timestamps
    end
  end
end
