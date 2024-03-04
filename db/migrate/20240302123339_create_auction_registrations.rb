class CreateAuctionRegistrations < ActiveRecord::Migration[7.0]
  def change
    create_table :auction_registrations, id: :uuid do |t|
      t.references :auction, null: false, foreign_key: true, type: :uuid
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.integer :approval, default: 0
      t.string :delivery_phone
      t.string :delivery_city
      t.string :delivery_address
      t.boolean :terms

      t.timestamps
    end
  end
end
