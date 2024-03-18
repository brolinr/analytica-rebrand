# frozen_string_literal: true

class Lots::Create < ApplicationService
  def call
    preload(:company, :auction)

    handle_errors { step(:create_lot) }

    result
  end

  private

  def company
    @company ||= context[:company] || Company.find_by(id: params[:company_id])
  end

  def auction
    @auction ||= context[:auction] || Auction.find_by(id: params[:auction_id])
  end

  def create_lot
    lot = auction.lots.build(params)
    lot.collaborator = company
    handle_errors(lot) { assign_data(lot) if lot.save! }
  end
end
