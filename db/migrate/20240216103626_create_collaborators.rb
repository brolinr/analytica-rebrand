class CreateCollaborators < ActiveRecord::Migration[7.0]
  def change
    create_table :collaborators, id: :uuid do |t|
      t.references :company, null: false, foreign_key: true, type: :uuid
      t.references :auction, null: false, foreign_key: true, type: :uuid
      t.integer :acceptance_status, default: 0
      t.timestamps
    end
  end
end
