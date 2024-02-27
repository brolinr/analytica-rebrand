class ReverseAuction::CollaboratorsController < ReverseAuction::AuctionsController
  def index
    @pagy, @collaborators = pagy(current_company.collaborators.where(acceptance_status: :pending), items: 10)
  end

  def update

  end
  
end