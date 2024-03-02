class AddPolyRelationsToCollaborators < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key('collaborators', 'companies')
    remove_column(:collaborators, :company_id, type: :uuid)
    add_reference(:collaborators, :collaborator, type: :uuid, polymorphic: true)
  end
end
