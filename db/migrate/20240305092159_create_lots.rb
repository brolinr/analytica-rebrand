class CreateLots < ActiveRecord::Migration[7.0]
  def change
    create_table :lots, id: :uuid do |t|
      t.string :title
      t.text :description
      t.integer :asking_price_cents
      t.references :auction, null: false, foreign_key: true, type: :uuid
      t.references :collaborator, polymorphic: true, type: :uuid, null: true

      t.timestamps
    end
  end
end
