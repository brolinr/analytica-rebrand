class Auctions::Create < ApplicationService
  def call
    preload(:company)

    transaction do
      step(:create_auction)
      step(:add_collaborators)
    end

    result
  end

  def company
    @company ||= context[:company] || Company.find(params[:company_id])
  end

  private

  def create_auction
    @auction = company.auctions.build(params.except(:collaborator_ids))

    return assign_data(@auction) if @auction.save

    handle_validation_errors(@auction)
  rescue ActiveModel::UnknownAttributeError => e
    add_error(e)
  end

  def add_collaborators
    return unless @auction.is_a?(Auction) && params[:collaborator_ids]

    params[:collaborator_ids].each do |collaborator_id|
      next if collaborator_id.empty?
      collaborator = @auction.collaborators.build(company_id: collaborator_id)
      handle_validation_errors(collaborator) unless collaborator.save
    end
  end
end