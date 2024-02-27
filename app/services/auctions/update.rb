class Auctions::Update < ApplicationService
  def call
    preload(:auction)

    transaction do
      step(:update_auction)
      step(:update_collaborators)
    end

    result
  end

  private
  def auction
    @auction ||= context[:auction] || Auction.find(params[:id])
  end

  def update_auction
    return assign_data(auction) if auction.is_a?(Auction) && auction.update(params.except(:collaborator_ids))

    handle_validation_errors(auction)
  rescue ActiveModel::UnknownAttributeError => e
    add_error(e)
  end

  def update_collaborators
    collaborator_ids = clean_collaborator_ids(params[:collaborator_ids])
    return if collaborator_ids.nil?
    return auction.collaborators.destroy_all if collaborator_ids.empty?

    auction.collaborators.where.not(company_id: collaborator_ids).each(&:destroy!)
    collaborator_ids -= auction.collaborator_ids
    collaborator_ids.each do |id|
      next unless Company.exists?(id: id)
      next if Collaborator.exists?(company_id: id)

      collaborator = auction.collaborators.build(company_id: id)
      handle_validation_errors(collaborator) unless collaborator.save
    end
  end

  def clean_collaborator_ids(collaborator_ids)
    return if collaborator_ids.nil?

    collaborator_ids.reject { |id| id.to_s.empty? }
  end
end