# frozen_string_literal: true

class Collaborators::Update < ApplicationService
  def call
    preload(:collaborator)

    step(:update_collaborator)

    result
  end

  private

  def collaborator
    @collaborator ||= context[:collaborator] || Collaborator.find_by(params[:id])
  end

  def update_collaborator
    return add_error(I18n.t('flash.something_wrong')) if params[:acceptance_status].nil?

    handle_errors do
      add_error("Collaboration already #{acceptance_status}") unless collaborator.pending?
      assign_data(collaborator) if collaborator.update!(acceptance_status: params[:acceptance_status])
    end
  end
end
