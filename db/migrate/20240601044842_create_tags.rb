class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags, id: :uuid do |t|
      t.string :title
      t.references :taggable, polymorphic: true, type: :uuid, null: true

      t.timestamps
    end
  end
end
