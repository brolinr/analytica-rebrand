class CreateTenders < ActiveRecord::Migration[7.0]
  def change
    create_table :tenders, id: :uuid do |t|
      t.string :title
      t.string :location
      t.string :organisation
      t.datetime :deadline
      t.references :administrator, null: false, foreign_key: true, type: :bigint

      t.timestamps
    end
  end
end
