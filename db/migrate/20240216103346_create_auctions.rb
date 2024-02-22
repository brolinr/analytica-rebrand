class CreateAuctions < ActiveRecord::Migration[7.0]
  def change
    create_table :auctions, id: :uuid do |t|
      t.string :title
      t.datetime :starts_at
      t.datetime :closes_at
      t.references :company, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
