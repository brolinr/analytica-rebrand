# frozen_string_literal: true

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
    handle_errors do
      @auction = company.auctions.build(params.except(:collaborator_ids))
      handle_errors(@auction) { assign_data(@auction) if @auction.save! }
    end
  end

  def add_collaborators
    return unless @auction.is_a?(Auction) && params[:collaborator_ids]

    params[:collaborator_ids].each do |collaborator_id|
      next if collaborator_id.empty?

      handle_errors { @auction.collaborators.create!(collaborator_id: collaborator_id, collaborator_type: 'Company') }
    end
  end
end
