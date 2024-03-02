# frozen_string_literal: true

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
    handle_errors { assign_data(auction) if auction.update(params.except(:collaborator_ids)) }
  end

  def update_collaborators # rubocop:disable Metrics/CyclomaticComplexity
    collaborator_ids = clean_collaborator_ids(params[:collaborator_ids])
    return if collaborator_ids.nil?
    return auction.collaborators.destroy_all if collaborator_ids.empty?

    auction.collaborators.where.not(collaborator_id: collaborator_ids).each(&:destroy!)
    collaborator_ids -= auction.collaborator_ids
    collaborator_ids.each do |id|
      next unless Company.exists?(id: id)
      next if Collaborator.exists?(collaborator_id: id) || auction.company_id == id

      handle_errors { auction.collaborators.create!(collaborator_id: id, collaborator_type: 'Company') }
    end
  end

  def clean_collaborator_ids(collaborator_ids)
    collaborator_ids&.reject { |id| id.to_s.empty? }
  end
end
