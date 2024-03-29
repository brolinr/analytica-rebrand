# frozen_string_literal: true

class ReverseAuction::CollaboratorsController < ReverseAuction::ApplicationController
  def index
    @pagy, @collaborators = pagy(current_company.collaborations.pending_requests, items: 10)
  end

  def update
    result = Collaborators::Update.call(context: { collaborator: collaborator }, params: permitted_params)
    i18_string = result.success? && result.data.accept? ? 'accept' : 'decline'

    error_or_redirect(
      object: result,
      success_path: request.referer || reverse_auction_collaborators_path,
      failure_path: request.referer || reverse_auction_collaborators_path,
      success_string_key: "controllers.collaborators.#{i18_string}"
    )
  end

  private

  def permitted_params
    params.require(:collaborator).permit(:acceptance_status)
  end

  def collaborator
    @collaborator ||= current_company.collaborations.pending_requests.find_by(id: params[:id])
  end
end
