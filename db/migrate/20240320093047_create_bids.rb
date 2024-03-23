class CreateBids < ActiveRecord::Migration[7.0]
  def change
    create_table :bids, id: :uuid do |t|
      t.string :amount_cents
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.references :lot, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
